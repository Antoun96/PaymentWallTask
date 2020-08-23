//
//  QRScannerViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 23/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, QRScannerViewDelegate {

    @IBOutlet weak var qrScannerView: QRScannerView!
//    @IBOutlet weak var labelScannerMessage: UILabel!
//    
//    @IBOutlet weak var buttonCreate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        qrScannerView.delegate = self
        
        self.qrScannerView.startScanning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func qrScanningDidFail() {
        
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        
    }
    
    func qrScanningDidStop() {
        
    }

}
