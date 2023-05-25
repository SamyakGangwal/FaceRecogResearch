//
//  ContentView.swift
//  FaceRecogResearch
//
//  Created by GA on 5/25/23.
//

import SwiftUI

struct Introduction: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
    }
}
