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
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"
        let number = Double(price) ?? 0.0
        return numberFormatter.string(from: NSNumber(value: number)) ?? "$0.00"
    }
    
    var isFormValid: Bool {
        !name.isEmpty && Double(price) != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                HStack {
                    Text("$")
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .onChange(of: price) { _ in
                            price = formattedPrice
                        }
                }
                DatePicker("Date", selection: $date)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem (placement: .confirmationAction){
                    Button("Add") {
                        addExpense()
                    }
                    .disabled(!isFormValid)
                }
                ToolbarItem (placement: .topBarLeading){
                    Button("Cancel", role: .cancel) {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    func addExpense() {
        guard isFormValid else { return }
        
        let expense = Expense(context: moc)
        expense.id = UUID()
        expense.name = name
        expense.price = Double(price) ?? 0.0
        expense.date = date
        
        do {
            try moc.save()
        } catch {
            print("Error: \(error.localizedDescription)")
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
