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
    case AspectFit, AspectFill, Fill
}

@objc
public protocol JLVideoViewDelegate {
    func videoViewDidTap(videoView: JLVideoView) -> Void
}


public class JLVideoView: UIView {
    
    // MARK: - public
    
    ///  scaling mode
    public var scalingMode: ScalingMode = .AspectFit;
    /// delegate
    public weak var delegate: JLVideoViewDelegate?;
    ///  prevent other media playback stopping when start playing a resource
    public var allowMixSoundWithOthers: Bool = false;
    
    /**
     play video with NSURL.
     
     - parameter URL: a resource URL, remote or local.
     */
    public func playWithURL(URL: NSURL) -> Void {
        // create a new player and play.
        self.player = AVPlayer(URL: URL);
        play();
    }

    /**
     play video with AVPlayer. single player can be used in multiple JLVideoView.
     
     - parameter player: AVPlayer
     */
    public func playWithPlayer(player: AVPlayer) -> Void {
        // create a new player and play.
        self.player = player;
        play();
    }
    
    
    // MARK: - private
    
    private(set) var player: AVPlayer? = nil;
    private var tapRecognizer: UITapGestureRecognizer? = nil;
    
    override public class func layerClass() -> AnyClass {
        return AVPlayerLayer.self;
    }
    
    private func play() -> Void {
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
    
    private func videoGravity() -> String {
        switch(self.scalingMode) {
        case .AspectFit: return "AVLayerVideoGravityResizeAspect"
        case .AspectFill: return "AVLayerVideoGravityResizeAspectFill"
        case .Fill: return "AVLayerVideoGravityResize"
        }
    }
    
    internal func tapGestureRecognizerFired(recognizer: UITapGestureRecognizer) -> Void {
        if(self.delegate != nil) {
            self.delegate?.videoViewDidTap(self);
        }
    }
    
}
