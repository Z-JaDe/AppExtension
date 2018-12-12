//
//  SectionModelData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

public typealias Diffable = Differentiable
public typealias DiffableSection = DifferentiableSection
public typealias SectionModelItem = ArraySection

public protocol SectionModelType: DiffableSection {
    associatedtype Section
    typealias Item = Collection.Element
    var section: Section {get}
    var items: [Item] {get}
    init(original: Self, items: [Item])
}
extension SectionModelItem: SectionModelType {
    public typealias Section = Model
    public var section: Section {
        return self.model
    }
    public var items: [Item] {
        return self.elements
    }
    init(_ section: Model, _ items: [Element]) {
        self.init(model: section, elements: items)
    }
    public init(original: SectionModelItem<Model, Element>, items: [Element]) {
        self.init(source: original, elements: items)
    }
}
