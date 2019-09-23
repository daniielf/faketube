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
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var seeker: UISlider!
    
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
        

        
        videoScreenView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoScreenView.frame.width, height: videoScreenView.frame.height)
        
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player?.volume = 0
        player?.play()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 1).cgColor]
        gradientLayer.locations = [0.8, 1.1]
        gradientLayer.frame = videoScreenView.bounds
        videoScreenView.layer.addSublayer(gradientLayer)
    }
    
    func setupVideoControl() {
        controlView?.backgroundColor = UIColor(white: 0, alpha: 0.0)
        
        videoScreenView.bringSubview(toFront: controlView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchVideoPlayerStatus))
        controlView.addGestureRecognizer(tapGesture)
        
        seeker.value = 0
        seeker.addTarget(self, action: #selector(updateSeekerAndVideoTimer), for: .valueChanged)
        
        
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (time) in
            
            var timeS = time.seconds
            let timeMinutes = Int(timeS / 60)
            let timeSeconds = Int(timeS) % 60

            self.currentTimeLabel.text = String(format: "%.2d:%.2d", timeMinutes, timeSeconds)
            
            if let duration = self.player?.currentItem?.duration {
                let durationSeconds = duration.seconds
                self.seeker.setValue(Float(timeS / durationSeconds), animated: true)
            }
        })
        
    }
    
    @objc func updateSeekerAndVideoTimer() {
        let travelPercent = seeker.value
        
        if let time = self.player?.currentItem?.duration.seconds {
            let travelToTime = time * Double(travelPercent)
            let cgTime = CMTime(seconds: travelToTime, preferredTimescale: 1)
            player?.seek(to: cgTime)
        }
        
        
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    let timeSeconds = CMTimeGetSeconds((self.player?.currentItem?.duration)!)
                    
                    let durationSeconds = Int(timeSeconds) % 60
                    let durationMinutes = Int(timeSeconds / 60)

                    self.durationTimeLabel.text = String(format: "%.2d:%.2d", durationMinutes, durationSeconds)
                })
            default: break
            }
        }
    }

    
    func dismissThisView() {
        self.navigationController!.popViewController(animated: true)
    }
}
