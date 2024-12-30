//
//  AddExpenseButton.swift
//  budjet_tracker
//
//  Created by Rohit Deshmukh on 12/30/24.
//

import SwiftUI

struct AddExpenseButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    var body: some View {
        Button(action: action) {
            label()
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .padding()
    }
}


