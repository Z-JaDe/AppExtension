//
//  ItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift

public enum CellState {
    case prepare
    case willAppear
    case didAppear
    case didDisappear
    var isAppear: Bool {
        switch self {
        case .willAppear, .didAppear:
            return true
        case .prepare, .didDisappear:
            return false
        }
    }
}

extension ItemCell {
    public static var accessoryTypeUnSelectedImage: UIImage = UIImage(named: "ic_accessoryType_unselected") ?? UIImage()
    public static var accessoryTypeSelectedImage: UIImage = UIImage(named: "ic_accessoryType_selected") ?? UIImage()
}
open class ItemCell: CustomView, SelectedStateDesignable & HiddenStateDesignable & EnabledStateDesignable, HighlightedStateDesignable {
    // MARK: NeedUpdateProtocol
    private(set) var needUpdateSentinel: Sentinel = Sentinel()
    // MARK: selectedAccessoryType
    public lazy var selectedAccessoryTypeImageView: ImageView = ImageView(image: ItemCell.accessoryTypeSelectedImage)
    public lazy var unselectedAccessoryTypeImageView: ImageView = ImageView(image: ItemCell.accessoryTypeUnSelectedImage)
    // MARK: selectedBackgroundView
    let selectedBackgroundView: ItemCellSelectedBackgroundView = ItemCellSelectedBackgroundView()
    // MARK: - StateProtocol
    /// ZJaDe: isSelected由model和cell共同控制
    open var isSelected: Bool = false {
        didSet {
            if isSelected != oldValue {
                _updateSelectedState(isSelected)
            }
            updateSelectedState(isSelected)
        }
    }
    /// ZJaDe: 当isSelected状态更改时会适时调用该方法，在此作出处理
    open func updateSelectedState(_ isSelected: Bool) {

    }
    /// ZJaDe: 框架内部 更新 SelectedState，因为有时候updateSelectedState会忘了写super
    internal func _updateSelectedState(_ isSelected: Bool) {

    }
    /// ZJaDe: 如果canHighlighted值为false将不会出发点击cell的事件 如果仅仅是不想高亮 改变cell的selectionStyle属性
    open var canHighlighted: Bool = true
    /// ZJaDe: isHighlighted由cell控制
    open var isHighlighted: Bool = false {
        didSet { updateHighlightedState(isHighlighted) }
    }
    /// ZJaDe: 当isSelected状态更改时会适时调用该方法，在此作出处理, 子类需要调用super
    open func updateHighlightedState(_ isHighlighted: Bool) {

    }
    /// ZJaDe: isEnabled 由model层的isEnabled控制
    public var isEnabled: Bool = true {
        didSet { updateEnabledState(isEnabled) }
    }
    /// ZJaDe: 当isEnabled状态更改时会适时调用该方法，在此作出处理
    open func updateEnabledState(_ isEnabled: Bool) {

    }

    // MARK: - viewDidLoad
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: disappear
    public let cellState: BehaviorSubject<CellState> = BehaviorSubject(value: .prepare)
    /// ZJaDe: 一些准备工作
    open func prepareForReuse() {
        self.cellState.onNext(.prepare)
    }
    /// ZJaDe: 负责一些逻辑处理，但是不负责界面布局
    open func willAppear() {
        self.cellState.onNext(.willAppear)
    }
    func changeCellStateToDidAppear() {
        if (try? self.cellState.value()) == .willAppear {
            self.cellState.onNext(.didAppear)
        } else {
            assertionFailure("Cell状态不对\(String(describing: (try? self.cellState.value())))")
        }
    }
    /// ZJaDe: 负责一些逻辑处理，但是不负责界面布局
    open func didDisappear() {
        self.resetAppearDisposeBag()
        self.cellState.onNext(.didDisappear)
    }
    // MARK: - CellSelectProtocol
    /// ZJaDe: 点击cell回调闭包
    public let didSelectItemCallBacker: CallBackerNoParams = CallBackerNoParams()
    open func didSelectedItem() {
        self.sendDidSelectItemEvent()
    }
    func sendDidSelectItemEvent() {
        self.didSelectItemCallBacker.call()
    }

    // MARK: didLayoutSubviewsClosure
    var didLayoutSubviewsClosure: ((ItemCell) -> Void)?
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.didLayoutSubviewsClosure?(self)
    }
}
extension ItemCell: NeedUpdateProtocol {
    // TODO: 还未实现
    public func setNeedUpdate() {
        self.needUpdateSentinel.increase()
    }
}
extension ItemCell {
    /// ZJaDe: 检查是否可以高亮 列表代理方法会调用
    func shouldHighlight() -> Bool {
        guard canHighlighted else {
            return false
        }
        return isEnabled
    }
    public var appearDisposeBag: DisposeBag {
        self.disposeBagWithTag("_appear")
    }
    func resetAppearDisposeBag() {
        self.resetDisposeBagWithTag("_appear")
    }
}
