//
//  BulletText.swift
//  FaceRecogResearch
//
//  Created by GA on 7/21/23.
//

import SwiftUI

struct BulletPoint: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            Text("•")
                .font(.title) // Increased bullet point font size
            Text(text)
                .font(.title) // Increased instruction font size
        }
    }
}
