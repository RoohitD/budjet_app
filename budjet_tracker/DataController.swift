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
            }
        }
    }
    
    static var preview: DataController {
        let dataController = DataController()
        let viewContext = dataController.container.viewContext
        
        let expense = Expense(context: viewContext)
        expense.id = UUID()
        expense.name = "Test Expense"
        expense.price = 100.00
        expense.date = Date()
        
        try? viewContext.save()
        return dataController
    }
    
    
}
