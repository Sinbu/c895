//
//  SecondViewController.swift
//  c895
//
//  Created by Sina Yeganeh on 4/24/17.
//  Copyright © 2017 Sina Yeganeh. All rights reserved.
//

import UIKit
import Apptentive

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Test code
        // Apptentive.shared.engage(event: "test event", from: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func phoneButtonPressed(sender: UIButton) {
        let phoneNumber = "206-421-8989"
            if let phoneCallURL = URL(string: "tel:\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL)
                }
            }
        }
        
    }
}

