//
//  DataController.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/25/24.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Expense")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController()
        // Optionally, add some sample data here for preview purposes
        return dataController
    }()
    
    func ensureDefaultCategoryExists(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "No Category")
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let defaultCategory = CategoryEntity(context: context)
                defaultCategory.id = UUID()
                defaultCategory.name = "No Category"
                
                try context.save()
                print("Default 'No Category' created.")
                
            }
        } catch {
            print("Error checking/creating default category: \(error.localizedDescription)")
        }
    }
}
