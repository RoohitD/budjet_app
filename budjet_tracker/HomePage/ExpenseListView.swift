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
    
    enum ViewMode: String, CaseIterable, Identifiable {
        case date = "By Date"
        case category = "By Category"
        var id: String { self.rawValue }
    }
    
    @State private var selectedMode: ViewMode = .date
    
    var categorizedExpenses: [String: [ExpenseEntity]] {
        Dictionary(grouping: expenses) { expense in
            expense.expenseTocategory?.name ?? "No Category"
        }
    }
    var datedExpenses: [String: [ExpenseEntity]] {
        Dictionary(grouping: expenses) { expense in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/yyyy"
            return formatter.string(from: expense.date ?? Date.distantPast)
        }
    }
    
    var sortedDatedExpenses: [(key: String, value: [ExpenseEntity])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        
        return datedExpenses
            .sorted { lhs, rhs in
                let lhsDate = formatter.date(from: lhs.key) ?? Date.distantPast
                let rhsDate = formatter.date(from: rhs.key) ?? Date.distantPast
                return lhsDate > rhsDate // Sort most recent to least recent
            }
    }
    
    var body: some View {
        HStack {
            Spacer()
            Picker("Group By", selection: $selectedMode) {
                ForEach(ViewMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
        }
        List {
            if selectedMode == .date {
                ForEach(sortedDatedExpenses, id: \.key) { date in
                    Section(header: Text(date.key)) {
                        ForEach(date.value, id: \.self) { expense in
                            NavigationLink(value: expense) {
                                ExpenseListItem(expense: expense)
                            }
                        }
                        .onDelete{ offsets in
                            delete(expense: date.value, at: offsets)
                        }
                    }
                }
            }
            else if selectedMode == .category {
                ForEach(categorizedExpenses.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(categorizedExpenses[category] ?? [], id: \.self) { expense in
                            NavigationLink(value: expense) {
                                ExpenseListItem(expense: expense)
                            }
                        }
                        .onDelete{ offsets in
                            delete(expense: categorizedExpenses[category] ?? [], at: offsets)
                        }
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


