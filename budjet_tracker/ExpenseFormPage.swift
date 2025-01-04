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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: false)]) var categories: FetchedResults<CategoryEntity>
    @State private var selectedCategory: CategoryEntity? = nil
    @State private var showingAddCategorySheet: Bool = false
//    var formattedPrice: String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .currency
//        numberFormatter.currencySymbol = "$"
//        let number = Double(price) ?? 0.0
//        return numberFormatter.string(from: NSNumber(value: number)) ?? "$0.00"
//    }
    
    var isFormValid: Bool {
        !name.isEmpty && Double(price) != nil
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Expense Name", text: $name)
                    HStack {
                        Text("$")
                        TextField("Price", text: $price)
                            .keyboardType(.decimalPad)
//                            .onChange(of: price) { _, _ in
//                                price = formattedPrice
//                            }
                    }
                    DatePicker("Date", selection: $date)
                }
                
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.name ?? "Unnamed Category")
                                .tag(category as CategoryEntity?)
                        }
                        Divider()
                        Button(action: {
                            showingAddCategorySheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Category")
                            }
                        }
                        .foregroundColor(.blue)
                        
                    }
                }
            }
            .navigationTitle("Add Expense")
            .onAppear {
                if selectedCategory == nil {
                    let fallbackCategory = categories.indices.contains(1) ? categories[1] : nil
                    selectedCategory = categories.first(where: { $0.name == "No Category" }) ?? fallbackCategory
                }
            }
            .sheet(isPresented: $showingAddCategorySheet) {
                AddCategoryView(isPresented: $showingAddCategorySheet)
            }
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
        
        let expense = ExpenseEntity(context: moc)
        expense.id = UUID()
        expense.name = name
        expense.price = Double(price) ?? 0.0
        expense.date = date
        expense.expenseTocategory = selectedCategory ?? categories.first(where: { $0.name == "No Category"})
        
        do {
            try moc.save()
            isPresented = false
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
