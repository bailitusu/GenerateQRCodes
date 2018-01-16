//
//  MainViewController.swift
//  GenerateQRCodes
//
//  Created by cozhang  on 16/01/2018.
//  Copyright © 2018 cozhang . All rights reserved.
//

import UIKit
import CoreImage

class MainViewController: UIViewController {
    @IBOutlet weak var identityCard: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func scanQRAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanQRCodeViewController") as! ScanQRCodeViewController
        show(vc, sender: nil)
    }
    
    @IBAction func createQRAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowQRCodeViewController") as! ShowQRCodeViewController
        vc.qrImage = createQRCode()
        show(vc, sender: nil)
    }
    
    func createQRCode() -> UIImage {
        let stringData = ((nameTextField.text ?? "") + "_" + (identityCard.text ?? "")).data(using: .utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let qrCIImage = filter?.outputImage
        
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
        return codeImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}
