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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.qrScannerView.startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func qrScanningDidFail() {
        self.qrScannerView.startScanning()
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        if let code = str, let data = code.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any] {
            
            let d = json["data"] as! [String: Any]
            
            let transaction = Transaction(json: d)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentDetailsViewController") as! PaymentDetailsViewController
            
            vc.transaction = transaction
            
            self.show(vc, sender: self)
            
        } else {
            
            qrScanningDidFail()
        }
    }
    
    func qrScanningDidStop() {
        
    }

}
