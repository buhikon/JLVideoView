//
//  JLVideoView.swift
//
//  Version 0.1.0
//
//  Created by Joey L. on 1/28/16.
//  Copyright (c) 2016 Joey L. All rights reserved.
//
//  https://github.com/buhikon/JLVideoView
//

import UIKit
import AVFoundation

public enum ScalingMode: Int {
    case aspectFit, aspectFill, fill
}

@objc
public protocol JLVideoViewDelegate {
    func videoViewDidTap(_ videoView: JLVideoView) -> Void
}


open class JLVideoView: UIView {
    
    // MARK: - public
    
    ///  scaling mode
    open var scalingMode: ScalingMode = .aspectFit;
    /// delegate
    open weak var delegate: JLVideoViewDelegate?;
    ///  prevent other media playback stopping when start playing a resource
    open var allowMixSoundWithOthers: Bool = false;
    
    /**
     play video with NSURL.
     
     - parameter URL: a resource URL, remote or local.
     */
    open func playWithURL(_ URL: Foundation.URL) -> Void {
        // create a new player and play.
        self.player = AVPlayer(url: URL);
        play();
    }

    /**
     play video with AVPlayer. single player can be used in multiple JLVideoView.
     
     - parameter player: AVPlayer
     */
    open func playWithPlayer(_ player: AVPlayer) -> Void {
        // create a new player and play.
        self.player = player;
        play();
    }
    
    
    // MARK: - private
    
    fileprivate(set) var player: AVPlayer? = nil;
    fileprivate var tapRecognizer: UITapGestureRecognizer? = nil;
    
    override open class var layerClass : AnyClass {
        return AVPlayerLayer.self;
    }
    
    fileprivate func play() -> Void {
        if(self.player != nil) {
            (self.layer as! AVPlayerLayer).player = self.player
            (self.layer as! AVPlayerLayer).videoGravity = videoGravity()
            
            // audio session category
            self.player!.pause();
            let category = (self.allowMixSoundWithOthers == true) ? AVAudioSessionCategoryAmbient : AVAudioSessionCategorySoloAmbient;
            do {
                try AVAudioSession.sharedInstance().setCategory(category);
            }
            catch { print(error); }
            
            // play
            self.player!.play();
        }
        else {
            NSLog("[Error] could not play the video due to null instance of AVPlayer.");
        }
        
        
        if(self.tapRecognizer == nil) {
            self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerFired(_:)));
            self.addGestureRecognizer(self.tapRecognizer!);
        }
    }
    
    fileprivate func videoGravity() -> String {
        switch(self.scalingMode) {
        case .aspectFit: return "AVLayerVideoGravityResizeAspect"
        case .aspectFill: return "AVLayerVideoGravityResizeAspectFill"
        case .fill: return "AVLayerVideoGravityResize"
        }
    }
    
    internal func tapGestureRecognizerFired(_ recognizer: UITapGestureRecognizer) -> Void {
        if(self.delegate != nil) {
            self.delegate?.videoViewDidTap(self);
        }
    }
    
}
