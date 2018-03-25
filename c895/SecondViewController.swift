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
    
    @IBOutlet var messageCenterButton: UIButton!
    @IBOutlet var notificationBadgeImage: UIImageView!
    @IBOutlet var notificationBadgeNumber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // NotificationCenter.default.addObserver(self, selector: #selector(self.unreadMessageCountChanged), name: Notification.Name.ApptentiveMessageCenterUnreadCountChanged, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Test code
        Apptentive.shared.engage(event: "AboutScreenClicked", from: self)
        // TODO: Make this acutally use notifications
        unreadMessageCountChanged()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unreadMessageCountChanged() {
        let count = Apptentive.shared.unreadMessageCount
        // update UI with count
        print("Unread Message Count Changed - Count: \(count)")
        if count > 0 {
            notificationBadgeNumber.text = String(count)
            notificationBadgeNumber.isHidden = false
            notificationBadgeImage.isHidden = false
        } else {
            notificationBadgeNumber.isHidden = true
            notificationBadgeImage.isHidden = true
        }
        
    }
    
    @objc func unreadMessageCountChanged(notification: Notification) {
        print("Unread Message Count Changed")
        if let count = notification.userInfo?["count"] as? Int {
            // update UI with count
            if count > 0 {
                notificationBadgeNumber.text = String(count)
                notificationBadgeNumber.isHidden = false
                notificationBadgeImage.isHidden = false
            } else {
                notificationBadgeNumber.isHidden = true
                notificationBadgeImage.isHidden = true
            }
        }
        
    }
    
    @IBAction func feedbackButtonPressed(sender: UIButton) {
        Apptentive.shared.engage(event: "Presented Message Center", from: self)
        Apptentive.shared.presentMessageCenter(from: self)
        
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

