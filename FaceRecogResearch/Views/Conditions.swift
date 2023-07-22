//
//  SwiftUIView.swift
//  FaceRecogResearch
//
//  Created by GA on 7/6/23.
//

import SwiftUI

struct Conditions: View {
    @State public var selected = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Picker(selection: $selected, label: Text("Favorite Color")) {
                    Text("Control").tag(1)
                    Text("Face view").tag(2)
                    Text("No Face view").tag(3)
                }
                .pickerStyle(.segmented)
                
                
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        Introduction(selected_option: $selected)
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

struct Conditions_Previews: PreviewProvider {
    static var previews: some View {
        Conditions()
    }
}
