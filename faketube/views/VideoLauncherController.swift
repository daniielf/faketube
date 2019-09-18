//
//  VideoLauncherController.swift
//  faketube
//
//  Created by Daniel Freitas on 16/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit
import AVFoundation

protocol ErrorOnDisplayVideo {
    func errorOcurred()
}

class VideoLauncherController: UIViewController {
    
    var errorDetectionDelegate: ErrorOnDisplayVideo!
    var video: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let keyWindow = UIApplication.shared.keyWindow
        self.view = UIView(frame: keyWindow!.frame)
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        displayVideoPlayerScreen()
    }

    var videoToDisplay: Video?
    var videoPanel: UIView?
    var videoInfoView: UIView?
    var player: AVPlayer?
    
    var activityIndicator: UIActivityIndicatorView?
    
    func displayVideoPlayerScreen() {
        self.setupVideoPanel()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height - self.view.safeAreaInsets.top)
//            self.view.alpha = 1
//        }, completion: { _ in
//            self.setupVideoPanel()
//        })
    }
    
    func setupVideoInfo() {
        self.videoInfoView = UIView(frame: CGRect(x: 0, y: self.videoPanel!.frame.height, width: self.view.frame.width, height: 120))
        videoInfoView!.backgroundColor = .white
        
        view.addSubview(videoInfoView!)
        videoInfoView!.removeConstraints(videoInfoView!.constraints)
        
        let constraintLeading = NSLayoutConstraint(item: videoInfoView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            constraintLeading.isActive = true
        view.addConstraint(constraintLeading)

        let constraintTrailing = NSLayoutConstraint(item: videoInfoView, attribute: .trailing, relatedBy: .equal, toItem: self.view!, attribute: .trailing, multiplier: 1.0, constant: 0)
            constraintTrailing.isActive = true
        view.addConstraint(constraintTrailing)
        
        let titleLabel = UILabel()
        
        titleLabel.text = videoToDisplay!.title!
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 20)
        videoInfoView!.addSubview(titleLabel)
        videoInfoView!.addConstraintsWithFormat(format: "H:|-10-[v0]|", views: titleLabel)
        videoInfoView!.addConstraintsWithFormat(format: "V:|-8-[v0]", views: titleLabel)
        
        
        let numberOfViewsLabel = UILabel()
        numberOfViewsLabel.text = "\(videoToDisplay!.views!) Views"
        numberOfViewsLabel.textColor = .lightGray
        videoInfoView!.addSubview(numberOfViewsLabel)
        videoInfoView!.addConstraintsWithFormat(format: "V:[v0]-5-[v1]", views: titleLabel, numberOfViewsLabel)
        videoInfoView!.addConstraintsWithFormat(format: "H:[v0]-15-|", views: numberOfViewsLabel)

//        let titleViewsMargingConstraint = NSLayoutConstraint(item: numberOfViewsLabel, attribute: .topMargin, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10)
//        titleViewsMargingConstraint.isActive = true
//        videoInfoView.addConstraint(titleViewsMargingConstraint)
        
    }
    
    func setupGestureHandler(forView view: UIView) {
        view.isUserInteractionEnabled = true
        let tapHandler = UISwipeGestureRecognizer(target: self, action: #selector(self.anyAction(_:)))
        tapHandler.direction = .down
        view.addGestureRecognizer(tapHandler)
    }
    
    @objc func anyAction(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPanel?.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2)
            self.videoPanel?.alpha = 0
            
            self.videoPanel?.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2)
            self.videoPanel?.alpha = 0
            
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.dismissThisView()
        })
        
        UIView.animate(withDuration: 0.1, animations: {
            self.videoInfoView?.alpha = 0
        })
        
    }
    
    func setupVideoPanel() {
        let videoPanelHeight = self.view.frame.width * 9/16
        
        videoPanel = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: videoPanelHeight))
        videoPanel!.backgroundColor = .black
        
        self.view.addSubview(videoPanel!)
        let format = "V:|[v0(\(videoPanelHeight))]"
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: videoPanel!)
        self.view.addConstraintsWithFormat(format: format, views: videoPanel!)
        
        setupGestureHandler(forView: videoPanel!)
        setupVideoInfo()
        setupVideo()
    }
    
    func setupVideo() {
        guard videoToDisplay != nil else {
            self.errorDetectionDelegate?.errorOcurred()
            self.dismissThisView()
            return
        }

        let videoURL = URL(string: (videoToDisplay?.videoUrl!)!)
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        videoPanel!.layer.addSublayer(playerLayer)
        playerLayer.frame = videoPanel!.frame
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        videoPanel?.addSubview(activityIndicator!)
        
        activityIndicator?.centerXAnchor.constraint(equalTo: videoPanel!.centerXAnchor).isActive = true
        activityIndicator?.centerYAnchor.constraint(equalTo: videoPanel!.centerYAnchor).isActive = true
//        let centerX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: videoPanel, attribute: .centerX, multiplier: 0, constant: 1.0)
//            centerX.isActive = true
//        videoPanel?.addConstraint(centerX)
//
//        let centerY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: videoPanel, attribute: .centerY, multiplier: 1.0, constant: 0)
//            centerY.isActive = true
//        videoPanel?.addConstraint(centerY)
        
        activityIndicator?.color = .white
        activityIndicator?.startAnimating()
        
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player?.volume = 0
        player?.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status), let statusNumber = change?[.newKey] as? NSNumber {
            switch statusNumber.intValue {
            case AVPlayerItem.Status.readyToPlay.rawValue:
                activityIndicator?.stopAnimating()
//                let durationInSeconds = playerItem?.asset.duration.seconds ?? 0
                print("Ready to play")
            default: break
            }
        }
    }
    
    func dismissThisView() {
        self.navigationController!.popViewController(animated: true)
    }
    
    
}
