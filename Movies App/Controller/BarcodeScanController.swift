//
//  BarcodeScanController.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 15/06/24.
//

import UIKit
import AVFoundation

private let kDebugBarcodeScanController = "DEBUG BarcodeScanController: "
class BarcodeScanController: UIViewController {
    
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .black
        return btn
    }()
    
    private var captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resize
        layer.connection?.videoRotationAngle = .zero
        return layer
    }()
    
    var resultAfterDecodingHandler: ((String) -> Void)?
    
    public var metadata = [
        AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr,
        AVMetadataObject.ObjectType.aztec
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        requestForCameraAccess()
    }
    
    @objc func cancelButtonAction() {
        dismiss(animated: true)
    }
    
    private func configureUI() {
        captureVideoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(captureVideoPreviewLayer)
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20 ,width: 90, height: 35)
    }
    
    private func requestForCameraAccess() {
        
        // Get permission for Camera
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            
            if granted {
                print("REQUEST GRANTED!")
                
                DispatchQueue.main.async { [weak self] in
                    self?.setupCaptureSession()
                }
                
            } else {
                print("NOT ALLOWED!")
            }
        }
        
    }
    
    private func setupCaptureSession() {
        guard let captureDevice 
        else {
            print(kDebugBarcodeScanController, "Capture Device Not Found!")
            return
        }
        
        // Adding capture device input in capture session
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(kDebugBarcodeScanController, "capture device input error: \(error.localizedDescription)")
        }
        
        // Adding capture device output in capture session
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // NOTE: - add output to session first then set metadata types otherwise will get crash!
        captureSession.addOutput(output)
        output.metadataObjectTypes = metadata
        
       

        // Running capture session
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
}

extension BarcodeScanController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(kDebugBarcodeScanController, #function)
        
        guard !metadataObjects.isEmpty else { return }
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
              let requiredString = metadataObj.stringValue , metadata.contains(metadataObj.type) 
        else { return }
        
        // After decoding barcode
        processRequiredString(str: requiredString)
    }
    
    private func processRequiredString(str: String) {
        print(kDebugBarcodeScanController, "After decoding result => ",str)
        resultAfterDecodingHandler?(str)
        resultAfterDecodingHandler = nil
        dismiss(animated: true)
    }
}
