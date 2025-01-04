//
//  ExpenseDetailPage.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/27/24.
//

import SwiftUI

struct ExpenseDetailPage: View {
    let expense: ExpenseEntity
    
    var body: some View {
        VStack(spacing: 16) {
            Text(String(expense.price))
                .font(.largeTitle)
            Text("")
            Text(expense.name ?? "No Name")
                .font(.headline)
            Text(expense.expenseTocategory?.name ?? "No Category")
                .font(.caption)
            Text(DateFormatter().string(from: expense.date ?? Date()))
                .font(.caption) // Place holder date when no date
        }
    }
}

//#Preview {
//    ExpenseDetailPage(expense: Expense)
//}
