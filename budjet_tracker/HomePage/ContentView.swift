//
//  ContentView.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showExpenseForm = false
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)]) var expenses: FetchedResults<ExpenseEntity>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: false)]) var categories: FetchedResults<CategoryEntity>
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.price }
    }
    
    // Sample Picker options
    enum ViewMode: String, CaseIterable, Identifiable {
        case date = "By Date"
        case category = "By Category"
        var id: String { self.rawValue }
    }
    
    @State private var selectedMode: ViewMode = .date
    
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                VStack {
                    HStack {
                        // Header showing total amount
                        Text("Total: $\(totalAmount, specifier: "%.2f")")
                            .font(.headline)
                            .padding(25)
                        Spacer()
                        Picker("View Mode", selection: $selectedMode) {
                            ForEach(ViewMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .padding()
                    }
                    ExpenseListView()
                }
                .navigationTitle("Expenses")
                
                AddExpenseButton(action: {
                    showExpenseForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                }
                .sheet(isPresented: $showExpenseForm) {
                    ExpenseFormPage(moc: _moc, isPresented: $showExpenseForm)
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController.preview
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
    
}

