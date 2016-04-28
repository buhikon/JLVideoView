//
//  ViewController.swift
//  JLVideoView
//
//  Created by Joey L. on 01/28/2016.
//  Copyright (c) 2016 Joey L. All rights reserved.
//

import UIKit
import AVFoundation
import JLVideoView

class ViewController: UIViewController {

    @IBOutlet var videoViews: [JLVideoView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URL = NSBundle.mainBundle().URLForResource("Clash Royale- Enter the Arena", withExtension: "mp4")
        let player = AVPlayer.init(URL: URL!)
        
        for videoView in videoViews {
            videoView.allowMixSoundWithOthers = true
            videoView.playWithPlayer(player)
        }
    }
}

