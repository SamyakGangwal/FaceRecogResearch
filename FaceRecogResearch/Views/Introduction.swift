//
//  ContentView.swift
//  FaceRecogResearch
//
//  Created by GA on 5/25/23.
//

import SwiftUI

struct Introduction: View {
    @Binding var selected_option: Int
    let card = Card(text: "Hello - thank you for taking part in this study. We’re exploring user experience of a mobile application. Please read the instructions carefully as you proceed.\n\nNext screen presents a consent form.")
    var body: some View {
        NavigationStack {
            Spacer()
            VStack(alignment: .center) {
                CardView(card: card)
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        Consent(selected_option: $selected_option)
                    } label: {
                        Text("Next")
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
