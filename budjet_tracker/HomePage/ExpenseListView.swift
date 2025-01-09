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
    var arrangedExpenses: [(key: String, value: [ExpenseEntity])]
    
    var body: some View {
        List {
            ForEach(arrangedExpenses, id: \.key) { keys in
                Section(header: Text(keys.key)) {
                    ForEach(keys.value, id: \.self) { expense in
                        NavigationLink(value: expense) {
                            ExpenseListItem(expense: expense)
                        }
                    }
                    .onDelete { offsets in
                        delete(expense: keys.value, at: offsets)
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


