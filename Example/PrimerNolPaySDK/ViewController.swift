//
//  ViewController.swift
//  PrimerNolPaySDK
//
//  Created by Boris Nikolic on 08/14/2023.
//  Copyright (c) 2023 Boris Nikolic. All rights reserved.
//

import UIKit
import CoreNFC
import PrimerNolPaySDK

class ViewController: UIViewController {
    
    var nolPay: PrimerNolPay!
    override func viewDidLoad() {
        super.viewDidLoad()
        nolPay = PrimerNolPay(appId: "1301", isDebug: true, isSandbox: true)
    }
    
    @IBAction func onScanNFCButtonTap(_ sender: Any) {
        DispatchQueue.main.async {
            self.nolPay.scanNFCCard { result in
                switch result {
                    
                case .success(let cardNumber):
                    print(cardNumber)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
