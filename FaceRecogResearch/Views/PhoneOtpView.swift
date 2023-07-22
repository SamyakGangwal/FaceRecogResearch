//
//  PhoneOtpView.swift
//  FaceRecogResearch
//
//  Created by GA on 7/21/23.
//

import SwiftUI

struct PhoneOtpView: View {
    @State private var phoneNumber = ""
    @State private var confirmationCode = ""
    @State private var isNextButtonEnabled = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your phone number:")
                TextField("617-287-5000", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: phoneNumber) { newValue in
                        isNextButtonEnabled = isValidPhoneNumber(newValue) && isValidConfirmationCode(confirmationCode)
                    }
                
                Text("Enter your confirmation code:")
                TextField("8923", text: $confirmationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: confirmationCode) { newValue in
                        isNextButtonEnabled = isValidPhoneNumber(phoneNumber) && isValidConfirmationCode(newValue)
                    }
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        SuccessView()
                    } label: {
                        Text("Next")
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .buttonStyle(.bordered)
                    .disabled(!isNextButtonEnabled)
                }
            }
            .padding()
        }
    }
    
    private func isValidPhoneNumber(_ number: String) -> Bool {
        return number == "617-287-5000"
    }
    
    private func isValidConfirmationCode(_ code: String) -> Bool {
        return code == "8923"
    }
}
