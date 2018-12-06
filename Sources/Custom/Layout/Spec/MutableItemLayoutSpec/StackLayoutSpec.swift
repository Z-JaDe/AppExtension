//
//  StackLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import SnapKit

public enum StackLayoutDirection {
    case vertical
    case horizontal
}
public enum StackLayoutJustifyContent {
    case start(CGFloat)
    case center(CGFloat)
    case end(CGFloat)
    case spaceBetween(CGFloat, CGFloat)
}

public class StackLayoutSpec: MutableItemLayoutSpec {
    private let stackView: UIStackView = UIStackView()
    public var spacing: CGFloat {
        get {return stackView.spacing}
        set {stackView.spacing = newValue}
    }
    public var distribution: UIStackView.Distribution {
        get {return stackView.distribution}
        set {stackView.distribution = newValue}
    }
    public var alignment: UIStackView.Alignment {
        get {return stackView.alignment}
        set {stackView.alignment = newValue}
    }
    public var isLayoutMarginsRelativeArrangement: Bool {
        get {return stackView.isLayoutMarginsRelativeArrangement}
        set {stackView.isLayoutMarginsRelativeArrangement = newValue}
    }
    // MARK: -
    public var direction: StackLayoutDirection = .horizontal {
        didSet {if direction != oldValue {setNeedUpdateLayout()}}
    }
    public var justifyContent: StackLayoutJustifyContent = .spaceBetween(0, 0) {
        didSet {setNeedUpdateLayout()}
    }
    public convenience init(_ childArr: [LayoutElement], _ direction: StackLayoutDirection, _ justifyContent: StackLayoutJustifyContent) {
        self.init(childArr)
        self.direction = direction
        self.justifyContent = justifyContent
    }
    override func addChild() {
        self.addSubview(self.stackView)
        self.childArr.forEach { (child) in
            self.stackView.addArrangedSubview(child)
        }
    }

    override func updateLayout() {
        super.updateLayout()
        switch self.direction {
        case .horizontal:
            self.stackView.axis = .horizontal
        case .vertical:
            self.stackView.axis = .vertical
        }
    }
    public override func layoutArr() -> [Constraint] {
        return super.layoutArr() + self.stackView.snp.prepareConstraints({ (maker) in
            layoutJustifyContent(maker)
        })
    }
    func layoutJustifyContent(_ maker: ConstraintMaker) {
        func layout(_ makerOptions: MakerLayoutOptions) {
            switch self.direction {
            case .horizontal:
                maker.horizontal(self, makerOptions)
                maker.vertical(self, .fill(0, 0))
            case .vertical:
                maker.horizontal(self, .fill(0, 0))
                maker.vertical(self, makerOptions)
            }
        }
        switch self.justifyContent {
        case .start(let offSet):
            layout(.start(offSet))
        case .center(let offSet):
            layout(.centerOffset(offSet))
        case .end(let offSet):
            layout(.end(offSet))
        case .spaceBetween(let inset):
            layout(.fill(inset.0, inset.1))
        }
    }
}
