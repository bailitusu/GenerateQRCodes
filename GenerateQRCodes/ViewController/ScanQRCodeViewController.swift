//
//  ScanQRCodeViewController.swift
//  GenerateQRCodes
//
//  Created by cozhang  on 16/01/2018.
//  Copyright © 2018 cozhang . All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!

    var captureSession: AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        guard let input = try? AVCaptureDeviceInput.init(device: captureDevice)  else {
            return
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        view.bringSubview(toFront: messageLabel)
        createQRView()
    }
    
    func createQRView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    }
   
}

extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "no qr code"
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject =
                videoPreviewLayer?.transformedMetadataObject(for: metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}
