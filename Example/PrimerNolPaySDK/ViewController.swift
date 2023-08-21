//
//  ViewController.swift
//  PrimerNolPaySDK
//
//  Created by Boris Nikolic on 08/14/2023.
//  Copyright (c) 2023 Boris Nikolic. All rights reserved.
//

import UIKit
import PrimerNolPaySDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nolPay = PrimerNolPay(appId: "1301")
//        nolPay
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

