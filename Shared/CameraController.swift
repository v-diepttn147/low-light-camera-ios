//
//  CameraController.swift
//  AV Foundation
//
//  Created by Diep Tran on 27/05/2022.
//

import AVFoundation
import Photos

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

public enum CameraPosition {
    case front
    case rear
}

class CameraController {
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkSavePermission(completion: completion)
        checkPermission(completion: completion)
    }
    
    private func checkSavePermission(completion: @escaping (Error?) -> ()) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                guard status == .authorized else {return}
            })
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            return
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func checkPermission(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {
                [weak self] granted in
                guard granted else {return}
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
//                try device.lockForConfiguration()
//                do {
//                    let minISO = device.activeFormat.minISO
//                    let maxISO = device.activeFormat.maxISO
//                    let clampedISO = 0.1 * (maxISO - minISO) + minISO
//                    device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: clampedISO)
//                    device.unlockForConfiguration()
//                }
                
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }                
            } catch {
                completion(error)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.session = session
            
            session.startRunning()
            self.session = session
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
//        settings.flashMode = AVCaptureDevice.FlashMode.on
//        setting AVCaptureDevice.ExposureMode.locked
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
