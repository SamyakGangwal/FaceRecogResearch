//
//  BeginTrial.swift
//  FaceRecogResearch
//
//  Created by GA on 5/25/23.
//

import SwiftUI

struct BeginTrial: View {
    @Binding var selected_option: Int
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Trail will start now")
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        if selected_option == 1 {
                            SimpleListView()
                        } else if selected_option == 2 {
                            CameraView()
                        } else {
                            CircularProgressBarView()
                        }
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
