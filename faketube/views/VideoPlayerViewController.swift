//
//  VideoPlayerViewController.swift
//  faketube
//
//  Created by Daniel Freitas on 23/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoScreenView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoViewsLabel: UILabel!
    
    @IBOutlet weak var channelProfilePictureImageView: UIImageView!
    
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelSubsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIImageView!
    
    var video: Video?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        setupVideoInfo()
    }
    
    func setupVideoInfo() {
        guard let video = self.video else {
            return
        }
        
        self.videoTitleLabel.text = video.title
        self.videoViewsLabel.text = "\(video.views!) Views"
        
        self.channelName.text = video.channel?.name
        self.channelSubsLabel.text = "1.011.013 subscriptions"
        
        self.channelProfilePictureImageView.image = UIImage(named: video.channel!.profile_image!)
        self.channelProfilePictureImageView.layer.cornerRadius = self.channelProfilePictureImageView.frame.height / 2
        
        self.channelProfilePictureImageView.clipsToBounds = true
        
        setupPlayer()
    }
    
    func setupPlayer() {
        guard video?.videoUrl != nil else {
    //                    self.errorDetectionDelegate?.errorOcurred()
            self.dismissThisView()
            return
        }

        let videoURL = URL(string: ((video?.videoUrl)!))
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        
        videoScreenView!.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoScreenView.frame.width, height: videoScreenView.frame.height)
        
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player?.volume = 0
        player?.play()
        
    }
    
    func setupVideoControl() {
        controlView?.backgroundColor = UIColor(white: 0, alpha: 0.0)
        
        videoScreenView.bringSubview(toFront: controlView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchVideoPlayerStatus))
        
        controlView.addGestureRecognizer(tapGesture)
    }
    
    @objc func switchVideoPlayerStatus() {
        if player?.rate == 0 {
            player?.play()
            controlView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        } else {
            player?.pause()
            controlView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        }
        
        playButton.isHidden = !playButton.isHidden
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status), let statusNumber = change?[.newKey] as? NSNumber {
            switch statusNumber.intValue {
            case AVPlayerItem.Status.readyToPlay.rawValue:
                activityIndicator?.stopAnimating()
                activityIndicator.isHidden = true
                setupVideoControl()
                videoScreenView.bringSubview(toFront: controlView)

            default: break
            }
        }
    }

    
    func dismissThisView() {
        self.navigationController!.popViewController(animated: true)
    }
}
