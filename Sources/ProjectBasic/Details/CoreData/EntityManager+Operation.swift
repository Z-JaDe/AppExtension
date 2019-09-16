//
//  EntityManager+Operation.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/12/1.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import CoreData

extension EntityManager {
    // MARK: - 增
    /// ZJaDe: 创建model
    public func create<T>(_ closure: (T) -> Void) -> T where T: NSManagedObject {
        let contexts = self.managedContext
        let fetchRequest = T.fetchRequest()
        // swiftlint:disable force_cast
        let model = NSEntityDescription.insertNewObject(forEntityName: fetchRequest.entityName!, into: contexts) as! T
        // swiftlint:enable force_cast
        closure(model)
        saveContext()
        return model
    }
    /// ZJaDe: 创建model, 如果相关model已经存在无须重新创建
    public func createIfNeed<T>(keyValues: [(String, Any)], _ closure: (T) -> Void) -> T where T: NSManagedObject {
        let model: T
        if let result: T = searchFirst(keyValues: keyValues) {
            model = result
        } else {
            model = create { (model) in
                keyValues.forEach({ (keyValue) in
                    model.setValue(keyValue.1, forKey: keyValue.0)
                })
                closure(model)
            }
        }
        return model
    }
    // MARK: - 删
    /// ZJaDe: 删除所有相关model
    public func delete<T>(_ objects: [T]) where T: NSManagedObject {
        let contexts = self.managedContext
        for object in objects {
            contexts.delete(object)
            saveContext()
        }
    }
    public func delete<T>(keyValues: [(String, Any)]) -> [T] where T: NSManagedObject {
        let contexts = self.managedContext
        let objects: [T] = search(keyValues: keyValues)
        for object in objects {
            contexts.delete(object)
            saveContext()
        }
        return objects
    }
    // MARK: - 改
    /// ZJaDe: 更新所有相关model
    public func update<T>(keyValues: [(String, Any)], _ closure: (T) -> Void) -> [T] where T: NSManagedObject {
        let models: [T] = search(keyValues: keyValues)
        models.forEach { (model) in
            keyValues.forEach({ (keyValue) in
                model.setValue(keyValue.1, forKey: keyValue.0)
            })
            closure(model)
            saveContext()
        }
        return models
    }
    /// ZJaDe: 更新相关model中的第一个，如果不存在直接返回nil
    public func updateFirst<T>(keyValues: [(String, Any)], _ closure: (T) -> Void) -> T? where T: NSManagedObject {
        let model: T
        if let result: T = searchFirst(keyValues: keyValues) {
            model = result
            keyValues.forEach({ (keyValue) in
                model.setValue(keyValue.1, forKey: keyValue.0)
            })
            closure(model)
            saveContext()
            return model
        } else {
            return nil
        }
    }
    /// ZJaDe: 更新相关model中的第一个，如果不存在就创建一个新的
    public func updateFirstAndCreateIfNeed<T>(keyValues: [(String, Any)], _ closure: (T) -> Void) -> T where T: NSManagedObject {
        let model: T
        if let result: T = updateFirst(keyValues: keyValues, closure) {
            model = result
        } else {
            model = create { (model) in
                keyValues.forEach({ (keyValue) in
                    model.setValue(keyValue.1, forKey: keyValue.0)
                })
                closure(model)
            }
        }
        return model
    }
    // MARK: - 查
    /// ZJaDe: 查找所有相关model，谓词查找
    public func search<T>(predicate: NSPredicate? = nil) -> [T] where T: NSManagedObject {
        let contexts = self.managedContext
        // swiftlint:disable force_cast
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        // swiftlint:enable force_cast
        fetchRequest.predicate = predicate
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: fetchRequest.entityName!, in: contexts)
        do {
            return try contexts.fetch(fetchRequest)
        } catch {
            let error = error as NSError
            logError("查询错误: error: \(error), userInfo: \(error.userInfo)")
        }
        return []
    }
    /// ZJaDe: 查找所有相关model，根据keyValues查找
    public func search<T>(keyValues: [(String, Any)]) -> [T] where T: NSManagedObject {
        let objects: [T]
        if keyValues.isNotEmpty {
            let predicateFormat = keyValues.map {"\($0.0) == %@"}.joined(separator: "&&")
            let predicate: NSPredicate = NSPredicate(format: predicateFormat, argumentArray: keyValues.map {$0.1})
            objects = search(predicate: predicate)
        } else {
            objects = search(predicate: nil)
        }
        return objects
    }
    /// ZJaDe: 查找相关model中的第一个，根据keyValues查找
    public func searchFirst<T>(keyValues: [(String, Any)]) -> T? where T: NSManagedObject {
        search(keyValues: keyValues).first
    }

}
