//
//  Category+CoreDataProperties.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 1/2/25.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var categoryToexpense: NSSet?

}

// MARK: Generated accessors for categoryToexpense
extension Category {

    @objc(addCategoryToexpenseObject:)
    @NSManaged public func addToCategoryToexpense(_ value: Expense)

    @objc(removeCategoryToexpenseObject:)
    @NSManaged public func removeFromCategoryToexpense(_ value: Expense)

    @objc(addCategoryToexpense:)
    @NSManaged public func addToCategoryToexpense(_ values: NSSet)

    @objc(removeCategoryToexpense:)
    @NSManaged public func removeFromCategoryToexpense(_ values: NSSet)

}

extension Category : Identifiable {

}
