//
//  SecondViewController.swift
//  c895
//
//  Created by Sina Yeganeh on 4/24/17.
//  Copyright © 2017 Sina Yeganeh. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var callButton: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(somethingTapped(tapGestureRecognizer:)))
        callButton.isUserInteractionEnabled = true
        callButton.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func somethingTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let label = tapGestureRecognizer.view as! UILabel
        let phoneNumber = "2064218989"
        if (label == self.callButton) {
            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
}

