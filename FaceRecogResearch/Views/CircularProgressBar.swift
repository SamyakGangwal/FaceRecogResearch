////
////  CircularProgressBar.swift
////  FaceRecogResearch
////
////  Created by GA on 7/5/23.
////
//
import SwiftUI

struct CircularProgressView: View {
    // 1
    let progress: Double
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
            // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            // 1
                .animation(.easeOut, value: progress)
            
        }
    }
}

struct CircularProgressBarView: View {
    // 1
    @State var progress: Double = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                // 2
                CircularProgressView(progress: progress)
                // 3
                Text("\(progress * 100, specifier: "%.0f")")
                    .font(.largeTitle)
                    .bold()
            }.frame(width: 500, height: 500)
            Spacer()
            HStack {
                // 5
                Button("Reset") {
                    resetProgress()
                }.buttonStyle(.borderedProminent)
            }
        }
        .onReceive(timer) { _ in
            
            if progress < 0.9 {
                progress += 0.1
            } else {
                timer.upstream.connect().cancel() // Stop the timer when counter reaches 100
            }
            
        }
    }
    
    func resetProgress() {
        progress = 0
    }
    
    
}

struct CircularProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBarView()
    }
}
