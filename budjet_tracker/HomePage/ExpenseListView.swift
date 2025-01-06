//
//  ListItemView.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/30/24.
//

import SwiftUI

struct ExpenseListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)])
    var expenses: FetchedResults<ExpenseEntity>
    var groupedExpenses: [String: [ExpenseEntity]] {
        Dictionary(grouping: expenses) { expense in
            expense.expenseTocategory?.name ?? "No Category"
        }
    }
    
    var body: some View {
        // List of expenses
        List {
            ForEach(groupedExpenses.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(groupedExpenses[category] ?? [], id: \.self) { expense in
                        NavigationLink(value: expense) {
                            ExpenseListItem(expense: expense)
                        }
                    }
                    .onDelete{ offsets in
                        delete(expense: groupedExpenses[category] ?? [], at: offsets)
                    }
                }
            }
        }
        .navigationDestination(for: ExpenseEntity.self) { expense in
            ExpenseDetailPage(expense: expense)
        }
    }
    
    func delete(expense: [ExpenseEntity], at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            moc.delete(expense)
        }
        
        do {
            try moc.save()
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    var mockExpenses: Expense
//    ListItemView(expenses: mockExpenses)
//}


