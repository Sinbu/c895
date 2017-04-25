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
    
    @IBOutlet var playerView:UIView!
    var isPlaying:Bool = true;
    
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
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(playerView)
        
        // tweak your image frame here as-needed
    }
    
    deinit {
        // Be a good citizen
        // playerItem.removeObserver(self, forKeyPath: "timedMetadata")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        print("hit")
        isPlaying ? self.player?.pause() : self.player?.play()
        isPlaying = !isPlaying
    }


}

