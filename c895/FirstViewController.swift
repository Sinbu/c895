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
    @IBOutlet var playButtonImageView:UIImageView!
    
    var songName:String?
    var artistName:String?
    let logoImage:UIImage = UIImage(named: "C89.5 Logo With Slogan.jpg")!
    
    let playButtonImage:UIImage = UIImage(named: "Play Button.png")!
    let pauseButtonImage:UIImage = UIImage(named: "Pause Button.png")!
    
    var player:AVPlayer? = AVPlayer()
    var playerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        self.playRadio()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        playButtonImageView.isUserInteractionEnabled = true
        playButtonImageView.addGestureRecognizer(tapGestureRecognizer)
        
        // MARK: Notifications
        
        // Notification for AVAudioSession Interruption (e.g. Phone call)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionInterrupted),
                                               name: Notification.Name.AVAudioSessionInterruption,
                                               object: AVAudioSession.sharedInstance())
        
        NotificationCenter.default.addObserver(self, selector: #selector(stalledPlayback), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: playerItem)
        
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
            self.playPauseButton()
            return MPRemoteCommandHandlerStatus.success})
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                of object: Any?,
                                change: [NSKeyValueChangeKey : Any]?,
                                context: UnsafeMutableRawPointer?) {        // Get medatata, making sure to support a wider range of characters
        if let origMetaTitle = (playerItem?.timedMetadata?.first?.stringValue?.data(using: String.Encoding.isoLatin1, allowLossyConversion: true)) {
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
        
        playerItem?.removeObserver(self, forKeyPath: "timedMetadata")
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        // Make sure play button is updated
        self.updatePlayButtonStatus()
        
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
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if (tappedImage == self.playButtonImageView) {
            self.playPauseButton()
        }
    
    }
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
                    playerItem?.removeObserver(self, forKeyPath: "timedMetadata")
                    self.player = nil
                    self.playerItem = nil
                    self.playRadio()
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("Session Interruption ended - Do not resume playback")
                }
            }
        }
    }
    
    func updatePlayButtonStatus() {
        if (self.player != nil) {
            self.playButtonImageView.image = self.pauseButtonImage
        } else {
            self.playButtonImageView.image = self.playButtonImage
        }
    }
    
    func playRadio() {
        self.playButtonImageView.image = self.pauseButtonImage
        self.playerItem = AVPlayerItem(url: URL(string: "http://www.c895.org/streams/c895sc128.pls")!)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        // Get artist/song name
        playerItem?.addObserver(self, forKeyPath: "timedMetadata", options: [], context: nil)
        
        self.player?.play()
    }
    func pauseRadio() {
        self.playButtonImageView.image = self.playButtonImage
        self.player?.pause()
        playerItem?.removeObserver(self, forKeyPath: "timedMetadata")
        self.player = nil
        self.playerItem = nil
        
    }
    
    // MARK: IBActions
    @IBAction func playPauseButton() {
        self.player == nil ? playRadio() : pauseRadio()
    }
}

