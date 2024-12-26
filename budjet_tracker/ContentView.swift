//
//  ContentView.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var expenses: FetchedResults<Expense>
    
    
    var body: some View {
        VStack {
            List(expenses) { expense in
                Text(expense.name ?? "Unknown")
            }
            
            // let expense = Expense(context: moc)
            // expense.id = UUID()
            // expense.name = name
            // expense.price = price
            // expense.date = date
            // moc.save()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
