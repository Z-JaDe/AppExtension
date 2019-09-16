//
//  EntityManager.swift
//  SDK
//
//  Created by 茶古电子商务 on 2017/11/30.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import CoreData
public class EntityManager {
    let name: String
    let cls: AnyClass
    public init(name: String, in cls: AnyClass) {
        self.name = name
        self.cls = cls
    }

    // MARK: - Core Data stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle(for: self.cls).url(forResource: self.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.name, managedObjectModel: self.managedObjectModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                let errStr = "loadPersistentStores出错\(error), \(error.userInfo)"
                logError(errStr)
                assertionFailure(errStr)
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    var managedContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    public func saveContext() {
        let context = self.managedContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                let errStr = "数据保存出错\(nserror), \(nserror.userInfo)"
                logError(errStr)
                assertionFailure(errStr)
            }
        }
    }
}
