//
//  PageScrollViewController.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class PageScrollViewController: UIViewController, UIScrollViewDelegate {
    open override func loadView() {
        super.loadView()
        self.scrollView.frame = self.view.frame
        self.view = self.scrollView
    }
    public typealias CellView = UIView
    public typealias CellData = Void
    public lazy private(set) var scrollView: PageScrollView<UIView> = PageScrollView<UIView>()
    public var viewConArr: [UIViewController] = [] {
        didSet {
            guard oldValue != self.viewConArr else {
                return
            }
            oldValue.forEach { (viewCon) in
                self.removeAsChildViewController(viewCon)
            }
            self.scrollView.cleanCells()
            viewConArr.forEach { (viewCon) in
                self.addChild(viewCon)
            }
            checkCellsLifeCycle(isNeedUpdate: true)
            whenCurrentIndexChanged(self.currentIndex, self.currentIndex)

        }
    }
    public var scrollEndClosure: ((Int) -> Void)?
    /// ZJaDe:
    public var currentIndex: Int = 0 {
        didSet {
            whenCurrentIndexChanged(oldValue, self.currentIndex)
        }
    }
    public var totalCount: Int {
        self.viewConArr.count
    }

    var observer: NSKeyValueObservation?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        observer = self.scrollView.observe(\.contentOffset) {[weak self] (_, _) in
            self?.whenScroll()
        }
    }
    deinit {
        /// ZJaDe: ios10 无动画pop时，不手动调用invalidate会崩溃
        observer?.invalidate()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentLength = self.scrollView.length * self.viewConArr.count.toCGFloat
    }
    /// ZJaDe: 当currentIndex改变时
    internal func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        self.scroll(to: to)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkCellsLifeCycle(isNeedUpdate: true)
        }
    }
    // MARK: -
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        whenScrollBegin()
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            whenScrollEnd()
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        whenScrollEnd()
    }
    // MARK: -
    func whenScroll() {
        checkCellsLifeCycle(isNeedUpdate: false)
    }
    func whenScrollBegin() {
    }
    func whenScrollEnd() {
        checkCellsLifeCycle(isNeedUpdate: false)
        let index = realProgress(offSet: self.scrollView.viewHeadOffset(), length: self.scrollView.length).toInt
        self.scrollEndClosure?(index)
    }
    //    // ZJaDe: 手动控制问题太多
    //    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
    //        return false
    //    }
}
extension PageScrollViewController: CollectionReusableViewable {
    public func loadCell(_ currentOffset: CGFloat, _ indexOffset: Int, _ isNeedUpdate: Bool) {
        let length = self.scrollView.length
        let currentIndex = (currentOffset / length).toInt
        let offSet = currentOffset + indexOffset.toCGFloat * length
        let itemIndex = currentIndex + indexOffset
        guard (0..<self.scrollView.contentLength).contains(offSet) || isNeedUpdate == true else {
            /// ZJaDe: 防止滑动到开始或者结尾的时候 还加载了cell
            /// ZJaDe: isNeedUpdate为true时说明是手动加载的所以可以往下走。
            return
        }
        let viewCon = self.viewConArr[realIndex(itemIndex)]
        if viewCon.view.superview == nil {
            scrollView.add(viewCon.view, offSet: offSet, isToRight: indexOffset > 0)
            viewCon.didMove(toParent: self)
        }
    }
    /// ZJaDe: cell消失后回收
    public func didDisAppear(_ cell: CellView) {
        if let viewCon = cell.viewController(UIViewController.self) {
            viewCon.willMove(toParent: nil)
        }
        self.scrollView.remove(cell)
    }
}
