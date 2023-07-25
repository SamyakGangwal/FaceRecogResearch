//
//  FaceDetection.swift
//  FaceRecogResearch
//
//  Created by GA on 7/21/23.
//

import SwiftUI
import AVFoundation
import Vision

struct FaceRecognitionScreen: View {
    @State private var isFaceDetected = false
    @State private var isRecognitionDone = false
    @State private var progress: CGFloat = 0.0

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack {
                if !isRecognitionDone {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.3)
                            .foregroundColor(Color.blue)
                        Circle()
                            .trim(from: 0, to: min(progress, 1.0))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.blue)
                            .rotationEffect(Angle(degrees: -90))

                        Text("\(Int(progress * 100))%")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .onAppear(perform: startFaceDetection)
                    .onReceive(timer) { _ in
                        if progress >= 1.0 {
                            timer.upstream.connect().cancel()
                            isRecognitionDone = true
                            isFaceDetected = true
                        } else {
                            progress += 0.01
                        }
                    }
                } else {
                    Text("Successfully recognized the face!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Spacer()

                if isFaceDetected {
                    VStack {
                        Text("Face recognition successful, please proceed to the next screen")
                            .foregroundColor(.green)
                            .font(.headline)
                            .padding()

                        NavigationLink {
                            SuccessView()
                        } label: {
                            Text("Next")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                    }
                }
            }

        }
    }

    func startFaceDetection() {
        guard let image = UIImage(named: "user_face") else { return } // Replace "user_face" with the actual image name or use the appropriate method to capture the user's face.

        let request = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print("Face detection error: \(error)")
                return
            }

            guard let _ = request.results as? [VNFaceObservation] else {
                return
            }

            isFaceDetected = true
        }

        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform face detection: \(error)")
        }
    }
}
