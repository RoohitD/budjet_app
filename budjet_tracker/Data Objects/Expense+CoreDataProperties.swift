//
//  Expense+CoreDataProperties.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 1/2/25.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var expenseTocategory: Category?

}

extension Expense : Identifiable {

}
