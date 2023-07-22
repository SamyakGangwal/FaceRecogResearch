//
//  InstructionC.swift
//  FaceRecogResearch
//
//  Created by GA on 7/21/23.
//

import SwiftUI

struct InstructionC: View {
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(alignment: .leading, spacing: 5) {
                    BulletPoint("Imagine you’re about to order some fast food from a chain store app on your smartphone. You open the app, and a message pops up, saying, '20% off when you sign up for face payment.'")
                    BulletPoint("You decide to give it a try. You follow the signup instruction, and the app asks you to scan your face to proceed.")
                }
                .padding(.horizontal)
                
            }
            .padding()
            
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    FaceRecognitionScreen()
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
