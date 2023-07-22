import SwiftUI
import AVFoundation
import Vision

class CameraModel: ObservableObject {
    @Published var isFaceDetected = false
    @Published var isFaceDetectedFor3Seconds = false // Regular @Published property
}

struct CameraView: View {
    @ObservedObject private var cameraModel = CameraModel()
    @State private var navigateToNextScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(cameraModel: cameraModel)
                    .mask(HoleMask())
                
                if !cameraModel.isFaceDetected {
                    Text("Please keep your face inside the circle")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .transition(.opacity)
                        .onAppear {
                            withAnimation {
                                cameraModel.isFaceDetectedFor3Seconds = false
                            }
                        }
                }
                
                if cameraModel.isFaceDetected && cameraModel.isFaceDetectedFor3Seconds {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100)
                        .transition(.scale)
                        .onAppear {
                            if !navigateToNextScreen {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    navigateToNextScreen = true
                                }
                            }
                        }
                }
            }
            .onAppear {
                cameraModel.isFaceDetectedFor3Seconds = false // Reset the isFaceDetectedFor10Seconds when the view appears
            }
            
            if navigateToNextScreen {
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

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraModel: CameraModel
    
    func makeUIView(context: Context) -> CameraViewUI {
        let view = CameraViewUI()
        view.cameraModel = cameraModel
        return view
    }
    
    func updateUIView(_ uiView: CameraViewUI, context: Context) {}
}

class CameraViewUI: UIView {
    private var captureSession: AVCaptureSession?
    var cameraModel: CameraModel?
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var videoOutputQueue = DispatchQueue(label: "VideoOutputQueue")
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startFaceDetection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startFaceDetection() {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Front camera not available.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
                videoDataOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
                if captureSession.canAddOutput(videoDataOutput) {
                    captureSession.addOutput(videoDataOutput)
                }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    captureSession.startRunning()
                }
                
                DispatchQueue.main.async {
                    self.previewLayer.session = captureSession
                    self.previewLayer.frame = self.bounds
                    self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    self.layer.addSublayer(self.previewLayer)
                }
            }
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds // Update the previewLayer frame when the view's frame changes
    }
}

extension CameraViewUI: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        if let pixelBuffer = pixelBuffer, let cameraModel = cameraModel {
            do {
                let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
                    if let observations = request.results as? [VNFaceObservation], !observations.isEmpty {
                        DispatchQueue.main.async {
                            let isFaceInsideHole = self?.isFaceInsideHole(faceObservation: observations.first!)
                            cameraModel.isFaceDetected = isFaceInsideHole ?? false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self?.cameraModel?.isFaceDetectedFor3Seconds = isFaceInsideHole ?? false
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            cameraModel.isFaceDetected = false
                            cameraModel.isFaceDetectedFor3Seconds = false
                        }
                    }
                }
                
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
                try handler.perform([faceDetectionRequest])
            } catch {
                print("Error performing face detection: \(error)")
            }
        }
    }
    
    private func isFaceInsideHole(faceObservation: VNFaceObservation) -> Bool {
        let holeDiameter: CGFloat = 600
        let holeRect = CGRect(x: bounds.midX - holeDiameter / 2, y: bounds.midY - holeDiameter / 2, width: holeDiameter, height: holeDiameter)
        let faceRect = VNImageRectForNormalizedRect(faceObservation.boundingBox, Int(bounds.width), Int(bounds.height))
        return holeRect.contains(faceRect)
    }
}

/**
 
 import SwiftUI
 import Vision
 import AVFoundation
 
 struct PreviewSizePreferenceKey: PreferenceKey {
 typealias Value = CGSize
 
 static var defaultValue: CGSize = .zero
 
 static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
 let newSize = nextValue()
 if newSize != .zero {
 value = newSize
 }
 }
 }
 
 class CameraSession: NSObject, ObservableObject {
 @Published var faceRectangles: [FaceRectangle] = []
 
 internal var captureSession: AVCaptureSession?
 
 override init() {
 super.init()
 startCamera()
 }
 
 func startCamera() {
 DispatchQueue.global(qos: .userInitiated).async { [weak self] in
 guard let self = self else { return }
 
 guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
 
 self.captureSession = AVCaptureSession()
 
 guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
 self.captureSession?.addInput(captureInput)
 
 let captureOutput = AVCaptureVideoDataOutput()
 captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
 self.captureSession?.addOutput(captureOutput)
 
 self.captureSession?.startRunning()
 }
 }
 
 func stopCamera() {
 captureSession?.stopRunning()
 }
 }
 
 extension CameraSession: AVCaptureVideoDataOutputSampleBufferDelegate {
 func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
 guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
 
 let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
 if let error = error {
 print("Face detection error: \(error)")
 return
 }
 
 guard let observations = request.results as? [VNFaceObservation] else { return }
 
 DispatchQueue.main.async {
 self?.faceRectangles = observations.map { observation in
 let flippedObservation = observation.boundingBox
 let flippedRect = CGRect(x: flippedObservation.origin.x,
 y: 1 - flippedObservation.origin.y - flippedObservation.size.height,
 width: flippedObservation.size.width,
 height: flippedObservation.size.height)
 return FaceRectangle(id: UUID(), rect: flippedRect)
 }
 }
 }
 
 try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
 }
 }
 
 struct FaceRectangle: Identifiable {
 var id: UUID
 var rect: CGRect
 }
 
 struct CameraPreview: UIViewRepresentable {
 @ObservedObject var session: CameraSession
 @Binding var previewSize: CGSize
 
 func makeUIView(context: Context) -> UIView {
 let previewView = UIView(frame: .zero)
 
 DispatchQueue.main.async {
 guard let session = session.captureSession else { return }
 
 let previewLayer = AVCaptureVideoPreviewLayer(session: session)
 previewLayer.videoGravity = .resizeAspectFill
 previewLayer.connection?.videoOrientation = .portrait
 previewLayer.frame = previewView.bounds
 previewView.layer.addSublayer(previewLayer)
 
 previewSize = previewView.frame.size
 }
 
 return previewView
 }
 
 func updateUIView(_ uiView: UIView, context: Context) {
 guard let session = session.captureSession else { return }
 
 if !session.isRunning {
 session.startRunning()
 }
 }
 }
 
 
 
 struct CameraView: View {
 @EnvironmentObject private var cameraSession: CameraSession
 @State private var previewSize: CGSize = .zero
 
 var body: some View {
 GeometryReader { geometry in
 ZStack {
 CameraPreview(session: cameraSession, previewSize: $previewSize)
 
 ForEach(cameraSession.faceRectangles) { faceRect in
 let rect = CGRect(x: faceRect.rect.origin.x * geometry.size.width,
 y: faceRect.rect.origin.y * geometry.size.height,
 width: faceRect.rect.size.width * geometry.size.width,
 height: faceRect.rect.size.height * geometry.size.height)
 Rectangle()
 .stroke(Color.red, lineWidth: 2)
 .frame(width: rect.size.width, height: rect.size.height)
 .position(x: rect.midX, y: rect.midY)
 }
 }
 .onAppear {
 DispatchQueue.main.async {
 previewSize = geometry.size
 }
 }
 }
 .aspectRatio(contentMode: .fill)
 }
 }
 
 
 struct CameraViewDriver: View {
 @StateObject private var cameraSession = CameraSession()
 @State private var isCameraOn = false
 
 var body: some View {
 VStack {
 CameraView()
 .environmentObject(cameraSession)
 .edgesIgnoringSafeArea(.all)
 .onDisappear {
 cameraSession.stopCamera()
 }
 }
 }
 }
 
 
 import SwiftUI
 import AVFoundation
 import Vision
 
 struct CameraViewDriver: View {
 @State private var showNextScreen = false
 
 var body: some View {
 ZStack {
 CameraView()
 .edgesIgnoringSafeArea(.all)
 }
 .onAppear {
 AVCaptureDevice.requestAccess(for: .video) { success in
 if success {
 self.showNextScreen = true
 }
 }
 }
 }
 }
 
 struct CameraViewDriver_Previews: PreviewProvider {
 static var previews: some View {
 CameraViewDriver()
 }
 }
 
 struct CameraView: View {
 @State private var isScanning = false
 @State var progress: Double = 0
 let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 @State private var isScanSuccessfull: Bool = false
 
 var body: some View {
 if !isScanSuccessfull {
 ZStack {
 CameraPreview()
 .ignoresSafeArea()
 ZStack {
 // 2
 CircularProgressView(progress: progress)
 // 3
 Text("\(progress * 100, specifier: "%.0f")")
 .font(.largeTitle)
 .bold()
 }.frame(width: 700, height: 700)
 }
 .onReceive(timer) { _ in
 
 if progress < 0.9 {
 progress += 0.1
 } else {
 timer.upstream.connect().cancel() // Stop the timer when counter reaches 100
 isScanSuccessfull = true
 }
 
 }
 
 } else {
 SuccessView()
 }
 }
 }
 
 
 
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
 
 struct CameraPreview: UIViewRepresentable {
 func makeUIView(context: Context) -> UIView {
 let previewView = UIView()
 
 DispatchQueue.global(qos: .userInitiated).async {
 let captureSession = AVCaptureSession()
 
 guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
 let input = try? AVCaptureDeviceInput(device: frontCamera)
 else { return }
 
 captureSession.addInput(input)
 captureSession.startRunning()
 
 DispatchQueue.main.async {
 let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
 previewLayer.frame = previewView.bounds
 previewLayer.videoGravity = .resizeAspectFill
 previewView.layer.addSublayer(previewLayer)
 }
 }
 
 
 
 return previewView
 }
 
 func updateUIView(_ uiView: UIView, context: Context) {}
 }
 
 
 */


