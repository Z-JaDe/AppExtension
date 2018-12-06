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
    @available(iOS 10.0, *)
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
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as URL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle(for: self.cls).url(forResource: self.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try _ = coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let errStr = "addPersistentStore出错\(wrappedError), \(wrappedError.userInfo)"
            logError(errStr)
            assertionFailure(errStr)
        }

        return coordinator
    }()

    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    // MARK: - Core Data Saving support
    func managedContext() -> NSManagedObjectContext {
        let context: NSManagedObjectContext
        if #available(iOS 10.0, *) {
            context = persistentContainer.viewContext
        } else {
            context = managedObjectContext
        }
        return context
    }
    public func saveContext() {
        let context = managedContext()
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
