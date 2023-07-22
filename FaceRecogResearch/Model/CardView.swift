//
//  CardView.swift
//  FaceRecogResearch
//
//  Created by GA on 7/21/23.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)

            VStack {
                Text(card.text)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
            .padding(20)
            .multilineTextAlignment(.leading)
        }
        .frame(width: 500, height: 750)
    }
}
