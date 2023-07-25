//
//  successView.swift
//  FaceRecogResearch
//
//  Created by GA on 7/6/23.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            Text("Imagine you complete the signup following the instruction. A “Today’s Special” pops up, presenting a regular menu and a veggie menu at discounted prices (see the menus below). You proceed to choose a menu.")
                .padding()
                .font(.system(size: 30)) // Increase the font size to 18 or any desired size
            
            NavigationLink(destination: RegularMenuView()) {
                Text("Regular Menu")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            NavigationLink(destination: VeggieMenuView()) {
                Text("Veggie Menu")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}

struct RegularMenuView: View {
    var body: some View {
        Text("Regular Menu Screen")
    }
}

struct VeggieMenuView: View {
    var body: some View {
        Text("Veggie Menu Screen")
    }
}
