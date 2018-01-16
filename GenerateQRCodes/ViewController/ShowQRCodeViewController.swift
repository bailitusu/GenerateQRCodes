//
//  ShowQRCodeViewController.swift
//  GenerateQRCodes
//
//  Created by cozhang  on 16/01/2018.
//  Copyright © 2018 cozhang . All rights reserved.
//

import UIKit

class ShowQRCodeViewController: UIViewController {

    var qrImage: UIImage!
    
    @IBOutlet weak var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.image = qrImage
    }
}
