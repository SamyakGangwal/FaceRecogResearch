//
//  PreviewView.swift
//  FaceRecogResearch
//
//  Created by GA on 7/14/23.
//

import SwiftUI
import AVKit

struct PreviewView: UIViewRepresentable {
    @Binding var session: AVCaptureSession
    var layer: CALayer? // Add a layer property
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the UIView if needed
        if let layer = layer {
            // Remove any existing sublayers
            uiView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            // Set the provided layer as the new sublayer
            layer.frame = uiView.bounds
            uiView.layer.addSublayer(layer)
        }
    }
}
