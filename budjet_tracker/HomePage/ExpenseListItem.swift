//
//  ExpenseListItem.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/30/24.
//

import SwiftUI

struct ExpenseListItem: View {
    let expense: Expense
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.name ?? "Unknown")
                    .font(.headline)
                if let date = expense.date {
                    Text("\(date, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Text("$\(expense.price, specifier: "%.2f")")
                .font(.headline)
        }

    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

//#Preview {
//    ExpenseListItem()
//}
