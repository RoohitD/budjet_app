//
//  AddCategoryPage.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 1/4/25.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var isPresented: Bool
    @State private var newCategoryName: String = ""
    
    var isCategoryValid: Bool {
        !newCategoryName.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Category")) {
                    TextField("Category Name", text: $newCategoryName)
                }
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addCategory()
                    }
                    .disabled(!isCategoryValid)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    func addCategory() {
        guard isCategoryValid else { return }
        
        let newCategory = CategoryEntity(context: moc)
        newCategory.id = UUID()
        newCategory.name = newCategoryName
        
        do {
            try moc.save()
            newCategoryName = "" // Reset the field
            isPresented = false // Dismiss the sheet
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
