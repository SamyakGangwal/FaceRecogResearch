//
//  Consent.swift
//  FaceRecogResearch
//
//  Created by GA on 5/25/23.
//

import SwiftUI

struct Consent: View {
    @Binding var selected_option: Int
    @State private var agreedToParticipate: Bool = false
    
    // Consent form content data
    let consentFormData: [(title: String, content: String)] = [
        ("Description of the Project:", "The purpose of this research is to explore consumer experiences of a mobile application. Your participation in this study will take about 3 mins or so. If you decide to participate in this study, you will tap the \"next\" button below to proceed. You will use a simulated mobile application and answer some questions in a survey questionnaire will ask you to answer some questions, such as what you think about the use of the application, your evaluations of the application, and your thoughts about the overall experience. This study involves randomization. The probability for random assignment for any participant to any of the study groups is equal."),
        ("Benefits:", "Participants will have a chance to win a $100 gift card."),
        ("Risks or Discomforts:", "The researcher does not expect any risks or discomfort associated with taking the survey to be more than what you would encounter during a normal day."),
        ("Confidentiality:", "Participation in this study is anonymous. That is, the information gathered for this project will not be published or presented in a way that would allow anyone to identify you. Information gathered for this project will be password protected or stored on the researcher's personal computers, and only the researcher will have access to the data. The University of Massachusetts Boston Institutional Review Board (IRB) that oversees human research and other representatives of this organization may inspect and copy the information gathered for this project. Your information collected as part of this research will not be used or shared for future research studies, even if all of your identifiers are removed."),
        ("Voluntary Participation:", "The decision of whether or not to take part in this research study is voluntary. If you do decide to take part in this study, you may end your participation at any time without consequence. If you wish to end your participation, you should close the internet browser to terminate the online survey. Whatever you decide will in no way penalize you or involve a loss of benefits to which you are otherwise entitled."),
        ("Questions:", "You have the right to ask questions about this research before you agree to be in this study and at any time during the study. If you have further questions about this research or if you have a research-related problem, you can reach Prof. Vincent Xie by email (Vincent.Xie@umb.edu). If you have any questions or concerns about your rights as a research participant, please contact a representative of the Institutional Review Board (IRB), at the University of Massachusetts, Boston, which oversees research involving human participants. The Institutional Review Board may be reached by telephone or email at (617) 287-5374 or at human.subjects@umb.edu.")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Text("Consent Form")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(consentFormData, id: \.title) { data in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(data.title)
                                    .font(.headline)
                                Text(data.content)
                                    .fixedSize(horizontal: false, vertical: true) // Allow multiline text
                            }
                            .padding(.horizontal) // Add horizontal padding to align the benefits section
                        }
                    }
                }
                
                HStack {
                    Text("I HAVE READ THE CONSENT FORM AND I AGREE TO PARTICIPATE")
                    Spacer()
                    Checkbox(isChecked: $agreedToParticipate)
                }
                .padding()
                
                NavigationLink {
                    if selected_option == 1 {
                        InstructionA()
                    } else if selected_option == 2 {
                        InstructionB()
                    } else {
                        InstructionC()
                    }
                    
                } label: {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(agreedToParticipate ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .padding()
                }
                .disabled(!agreedToParticipate)
            }
        }
        .padding()
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(isChecked ? .blue : .gray)
        }
    }
}
