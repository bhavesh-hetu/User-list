
import Foundation
import CoreData

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: Constants.CoreData.dbName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    private lazy var persistanceCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("\(Constants.CoreData.dbName).sqlite")
        var failureResoinse = "Coredata failed"
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            var dictionary = [String : AnyObject]()
            dictionary[NSLocalizedDescriptionKey] = "Coredata save failed" as AnyObject?
            dictionary[NSLocalizedFailureReasonErrorKey] = "Coredata save failed" as AnyObject?
            dictionary[NSUnderlyingErrorKey] = error as NSError
            
            let wrapperError = NSError(domain: "ERROR_DOMAIN", code: 9999, userInfo: dictionary)
            print("UnResolvedError", wrapperError, wrapperError.userInfo)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext: NSManagedObjectContext?
        
        managedObjectContext = self.persistanceContainer.viewContext
        return managedObjectContext!
    }()
    
    lazy var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.CoreData.dbName)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError?{
                print("Unresolved error", error, error.userInfo)
                fatalError("Unresolved error \(error) \(error.userInfo)")
            }
        })
        return container
    }()
 
    func getManagedContext() -> NSManagedObjectContext {
        return self.persistanceContainer.viewContext
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let error = error as NSError
                print("Unresolved error", error, error.userInfo)
                abort()
            }
        }
    }
    
    func fetch(entityName: String) -> [NSManagedObject] {
        var managedObjects: [NSManagedObject] = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            managedObjects = try getManagedContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch", error, error.userInfo)
        }
        
        return managedObjects
    }
    
    func fetchWithPredicate(entityName: String, predicate: NSPredicate) -> [NSManagedObject] {
        var managedObjects: [NSManagedObject] = [NSManagedObject]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate

        do {
            managedObjects = try getManagedContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch", error, error.userInfo)
        }
        
        return managedObjects
    }
    
    func deleteWithPredicate(entityName: String, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate

        do {
            if let fetchRequest = try getManagedContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject] {
                for managedObject in fetchRequest {
                    getManagedContext().delete(managedObject)
                }
                try getManagedContext().save()
            }
        } catch let error as NSError {
            print("Could not fetch", error, error.userInfo)
        }
    }

}
