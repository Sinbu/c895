//
//  TodayViewController.swift
//  todayextension
//
//  Created by Sina Yeganeh on 5/1/17.
//  Copyright © 2017 Sina Yeganeh. All rights reserved.
//

import UIKit
import NotificationCenter
import MediaPlayer

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var artistAndSongName:UILabel!
    @IBOutlet var playPauseButton:UIButton!
    let shared = UserDefaults.init(suiteName: "group.Snigsoft.c895.ShareExtension")
    let imagePlayButtonSize = CGSize(width: 50, height: 50)
    var playButtonImage:UIImage? = nil
    var pauseButtonImage:UIImage? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.playButtonImage = self.imageWithImage(image: UIImage(named: "Play Button")!, scaledToSize: imagePlayButtonSize)
        self.pauseButtonImage = self.imageWithImage(image: UIImage(named: "Pause Button")!, scaledToSize: imagePlayButtonSize)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPauseRadio(sender:UIButton) {
        print("Button pressed")
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        shared?.synchronize()
        
        // Check for null value before setting
        if let restoredValue = shared!.string(forKey: "artistAndSongName") {
            artistAndSongName.text = restoredValue
        }
        else {
            artistAndSongName.text = ""
        }
        
        let restoredValue = shared!.bool(forKey: "playButtonShowing")
        restoredValue == true ? playPauseButton.setImage(pauseButtonImage, for: UIControlState.normal) : playPauseButton.setImage(playButtonImage, for: UIControlState.normal)
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
