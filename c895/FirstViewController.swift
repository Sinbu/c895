//
//  FirstViewController.swift
//  c895
//
//  Created by Sina Yeganeh on 4/24/17.
//  Copyright © 2017 Sina Yeganeh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FirstViewController: AVPlayerViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerItem = AVPlayerItem(url: URL(string: "http://www.c895.org/streams/c895sc128.pls")!)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.play()
        // AVPlayerItem = AVPlayerItem(url: URL(string: "http://www.c895.org/streams/c895sc128.pls")!)
        // player = AVPlayer(playerItem: playerItem)
        
        // To be informed when metadata changes
        // playerItem.addObserver(self, forKeyPath: "timedMetadata", options: [], context: nil)
    }
    
    deinit {
        // Be a good citizen
        // playerItem.removeObserver(self, forKeyPath: "timedMetadata")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

