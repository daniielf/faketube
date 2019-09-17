//
//  VideoLauncherController.swift
//  faketube
//
//  Created by Daniel Freitas on 16/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit
import AVFoundation

class VideoLauncherController: UIView {
    
    var videoToDisplay: String?
    var screenView: UIView?
    var videoPanel: UIView?
    
    var player: AVPlayer?
        
    func displayVideoPlayerScreen(errorHandling: @escaping ()->()) {
        print("Launching Screen...")
        guard let keyWindow = UIApplication.shared.keyWindow else {
            errorHandling()
            return
        }
        let view = UIView(frame: keyWindow.frame)
        
        
        view.frame = CGRect(x: keyWindow.frame.width - 160, y: keyWindow.frame.height - 100, width: 160, height: 100)
        view.alpha = 0
        view.backgroundColor = .white

        self.screenView = view
        keyWindow.addSubview(self.screenView!)
        
        UIView.animate(withDuration: 1.0, animations: {
            view.frame = CGRect(x: 0, y: keyWindow.safeAreaInsets.top, width: keyWindow.frame.width, height: keyWindow.frame.height - keyWindow.safeAreaInsets.top)
            view.alpha = 1
        }, completion: { _ in
      
            self.setupVideoPanel(errorHandling: errorHandling)

        })
        
        
    }
    
    func setupVideoPanel(errorHandling: ()->()) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        let videoPanelHeight = keyWindow.frame.width * 9/16
        videoPanel = UIView(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: videoPanelHeight))
        videoPanel!.backgroundColor = .black
        
        screenView?.addSubview(videoPanel!)
        let format = "V:|[v0(\(videoPanelHeight))]"
        screenView?.addConstraintsWithFormat(format: "H:|[v0]|", views: videoPanel!)
        screenView?.addConstraintsWithFormat(format: format, views: videoPanel!)
        
        setupVideo(errorHandling: errorHandling)
    }
    
    func setupVideo(errorHandling: ()->()) {
        guard videoToDisplay != nil else {
            print("DISMISS!!")
            videoPanel?.removeFromSuperview()
            screenView?.removeFromSuperview()
            errorHandling()
            return
        }
        
//        let videoURL = URL(fileURLWithPath: videoToDisplay!)
//        player = AVPlayer(url: videoURL)
    }
}
