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
            Text("Total: $10")
                .font(.headline)
                .padding()
            List {
                ForEach(expenses, id: \.id) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name ?? "Unknown")
                                .font(.headline)
                            Text("\(expense.date ?? Date(), formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(expense.price, specifier: "%.2f")")
                            .font(.headline)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
            Button("Add Expense") {
                do {
                    let expense = Expense(context: moc)
                    expense.id = UUID()
                    expense.name = "Walmart"
                    expense.price = 19.98
                    expense.date = Date()
                    
                    try moc.save()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        .padding()
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
