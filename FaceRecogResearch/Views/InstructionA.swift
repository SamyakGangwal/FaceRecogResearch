//
//  Instruction.swift
//  FaceRecogResearch
//
//  Created by GA on 5/25/23.
//

import SwiftUI

struct InstructionA: View {    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                BulletPoint("Imagine you're about to order some fast food from a chain store app on your smartphone. You open the app, and a message pops up, saying, \"20% off when you sign up for our text messaging list.\"")
                BulletPoint("You decide to give it a try. You follow the signup instruction, and the app asks you to enter your cell phone number. Please enter 617-287-5000 in the box below.")
                BulletPoint("Please enter 617-287-5000 in the box.")
                BulletPoint("Imagine you receive a 4-digit confirmation code.")
                BulletPoint("Please enter 8923 in the box.")
                
            }
            .padding()
            
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    PhoneOtpView()
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
