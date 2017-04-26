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
    let playerItem = AVPlayerItem(url: URL(string: "http://www.c895.org/streams/c895sc128.pls")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = AVPlayer(playerItem: playerItem)
        self.player.play()
        
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
            self.player.play()
            return MPRemoteCommandHandlerStatus.success})
        
        commandCenter.pauseCommand.addTarget(handler: { (event) in    // Begin playing the current track
            self.player.pause()
            return MPRemoteCommandHandlerStatus.success})
        
        commandCenter.togglePlayPauseCommand.addTarget(handler: { (event) in    // Toggle current track
            self.playPauseButton(nil)
            return MPRemoteCommandHandlerStatus.success})
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {        // Get medatata, making sure to support a wider range of characters
        let origMetaTitle = (playerItem.timedMetadata?.first?.stringValue?.data(using: String.Encoding.isoLatin1, allowLossyConversion: true))!
        let convertedMetaTitle = String(data: origMetaTitle, encoding: String.Encoding.utf8)!
        self.artistAndSongName.text = convertedMetaTitle
        let titleArr = convertedMetaTitle.components(separatedBy: "-")
        self.artistName = titleArr[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.songName = titleArr[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.updateNowPlayingInfoCenter()
    }
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: "timedMetadata")
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
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
    
    // MARK: IBActions
    @IBAction func playPauseButton(_ sender: UIButton?) {
        isPlaying ? self.player.pause() : self.player.play()
        isPlaying = !isPlaying
    }
}

