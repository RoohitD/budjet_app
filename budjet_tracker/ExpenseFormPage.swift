//
//  ExpenseFormPage.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/29/24.
//

import SwiftUI

struct ExpenseFormPage: View {
    @Environment(\.managedObjectContext) var moc
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var date: Date = Date.now
    @Binding var isPresented: Bool
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Expense Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.numberPad)
                DatePicker("Date", selection: $date)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem (placement: .confirmationAction){
                    Button("Add") {
                        
                        let newExpense = Expense(context: moc)
                        newExpense.id = UUID()
                        newExpense.name = name
                        newExpense.price = Double(price) ?? 0
                        newExpense.date = date
                        
                        do {
                            try moc.save()
                            isPresented = false
                        } catch {
                            print("Error saving expense: \(error.localizedDescription)")
                        }
                        
                    }
                }
                
                ToolbarItem (placement: .topBarLeading){
                    Button("Cancel", role: .cancel) {
                        isPresented = false
                    }
                }

            }
        }
    }
}

#Preview {
    struct Preview: View {
        @Environment(\.managedObjectContext) var moc
        @State var isPresented = true
        var body: some View {
            ExpenseFormPage(moc: _moc, isPresented: $isPresented)
        }
    }

    return Preview()
}
