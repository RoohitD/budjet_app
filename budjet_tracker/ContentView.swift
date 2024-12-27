//
//  ContentView.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)])
    var expenses: FetchedResults<Expense>
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header showing total amount
                Text("Total: $\(totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                
                // List of expenses
                List {
                    ForEach(expenses, id: \.self) { expense in
                        NavigationLink(value: expense) {
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
                }
                .navigationDestination(for: Expense.self) { expense in
                    ExpenseDetailPage(expense: expense)
                }
                
                // Add Expense button
                Button("Add Expense") {
                    addExpense()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Expenses")
        }
    }
    
    func addExpense() {
        let expense = Expense(context: moc)
        expense.id = UUID()
        expense.name = "Walmart"
        expense.price = 19.98
        expense.date = Date()
        
        do {
            try moc.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}

struct ContentVeiw_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
    
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
