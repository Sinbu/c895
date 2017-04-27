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
import MediaPlayer

class FirstViewController: UIViewController {
    
    @IBOutlet var artistAndSongName:UILabel!
    
    var isPlaying:Bool = true;
    var songName:String?
    var artistName:String?
    var logoImage:UIImage = UIImage(named: "logo2.png")!
    
    var player:AVPlayer = AVPlayer()
    var playerItem = AVPlayerItem(url: URL(string: "http://www.c895.org/streams/c895sc128.pls")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        self.player = AVPlayer(playerItem: playerItem)
        self.playRadio()
        
        // MARK: Notifications
        
        // Notification for AVAudioSession Interruption (e.g. Phone call)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionInterrupted),
                                               name: Notification.Name.AVAudioSessionInterruption,
                                               object: AVAudioSession.sharedInstance())
        
        NotificationCenter.default.addObserver(self, selector: #selector(stalledPlayback), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: playerItem)
        
        // Get artist/song name
        playerItem.addObserver(self, forKeyPath: "timedMetadata", options: [], context: nil)
        
        // Enable Audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .allowAirPlay)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        
        // Enable Control Center
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget(handler: { (event) in    // Begin playing the current track
            self.playRadio()
            return MPRemoteCommandHandlerStatus.success})
        
        commandCenter.pauseCommand.addTarget(handler: { (event) in    // Begin playing the current track
            self.pauseRadio()
            return MPRemoteCommandHandlerStatus.success})
        
        commandCenter.togglePlayPauseCommand.addTarget(handler: { (event) in    // Toggle current track
            self.playPauseButton(nil)
            return MPRemoteCommandHandlerStatus.success})
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                of object: Any?,
                                change: [NSKeyValueChangeKey : Any]?,
                                context: UnsafeMutableRawPointer?) {        // Get medatata, making sure to support a wider range of characters
        if let origMetaTitle = (playerItem.timedMetadata?.first?.stringValue?.data(using: String.Encoding.isoLatin1, allowLossyConversion: true)) {
            let convertedMetaTitle = String(data: origMetaTitle, encoding: String.Encoding.utf8)!
            self.artistAndSongName.text = convertedMetaTitle
            let titleArr = convertedMetaTitle.components(separatedBy: "-")
            self.artistName = titleArr[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.songName = titleArr[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.updateNowPlayingInfoCenter()
            self.setupUserActivity()
        }
    }
    
    deinit {
        print("Deinit")
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.AVAudioSessionInterruption,
                                                  object: AVAudioSession.sharedInstance())
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.AVPlayerItemPlaybackStalled,
                                                  object: self.playerItem)
        
        playerItem.removeObserver(self, forKeyPath: "timedMetadata")
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Functions
    private func updateNowPlayingInfoCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: self.songName ?? "Unknown Song",
            MPMediaItemPropertyArtist: self.artistName ?? "Unknown Artist",
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: self.logoImage)
        ]
    }
    
    func setupUserActivity() {
        let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity = activity
        let url = "https://www.google.com/search?q=\(self.artistName ?? "")+\(self.songName ?? "")"
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let searchURL : URL = URL(string: urlStr!)!
        activity.webpageURL = searchURL
        userActivity?.becomeCurrent()
    }
    
    func stalledPlayback(notification:NSNotification) {
        print("Playback stalled")
        print(notification)
    }
    
    func sessionInterrupted(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            // Interruption began, take appropriate actions
            print("Session Interruption began")
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options == .shouldResume {
                    // Interruption Ended - playback should resume
                    print("Session Interruption ended - Resume playback")
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("Session Interruption ended - Do not resume playback")
                }
            }
        }
    }
    
    func playRadio() {
        
        self.player.play()
    }
    func pauseRadio() {
        self.player.pause()
    }
    
    // MARK: IBActions
    @IBAction func playPauseButton(_ sender: UIButton?) {
        isPlaying ? self.pauseRadio() : self.playRadio()
        isPlaying = !isPlaying
    }
}

