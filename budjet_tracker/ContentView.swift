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
    @State private var showExpenseForm = false
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                VStack {
                    HStack {
                        Spacer()
                        // Header showing total amount
                        Text("Total: $\(totalAmount, specifier: "%.2f")")
                            .font(.headline)
                            .padding()
                    }
                    
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
                        .onDelete(perform: delete)
                    }
                    .navigationDestination(for: Expense.self) { expense in
                        ExpenseDetailPage(expense: expense)
                    }
                }
                .navigationTitle("Expenses")
                
                Button {
                    showExpenseForm = true
                    // addExpense()
                } label: {
                    Image(systemName: "plus")
                }
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
                .sheet(isPresented: $showExpenseForm) {
                    ExpenseFormPage(moc: _moc, isPresented: $showExpenseForm)
                }
            }
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

