//
//  ListItemView.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/30/24.
//

import SwiftUI

struct ExpenseListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)])
    var expenses: FetchedResults<Expense>
    
    var body: some View {
        // List of expenses
        List {
            ForEach(expenses, id: \.self) { expense in
                NavigationLink(value: expense) {
                    ExpenseListItem(expense: expense)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationDestination(for: Expense.self) { expense in
            ExpenseDetailPage(expense: expense)
        }
    }
    
    func delete(at offsets: IndexSet) {
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


