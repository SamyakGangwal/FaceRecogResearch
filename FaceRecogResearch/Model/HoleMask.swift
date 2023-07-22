//
//  HoleMask.swift
//  FaceRecogResearch
//
//  Created by GA on 7/22/23.
//

import SwiftUI

struct HoleMask: View {
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .frame(width: 600, height: 600)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .opacity(1)
        }
    }
}
