//
//  HomeCollectionAsCell.swift
//  faketube
//
//  Created by Daniel Freitas on 15/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit

protocol VideoDisplayDelegate {
    func displayVideo(_ video: Video)
}

class HomeCollectionAsCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let _videoCell = "VideoCell"
    let randomCell = "_cell"
    var dataSource: [Video] = []
    var controller: MainController?
    
    
    var videoDisplayDelegator: VideoDisplayDelegate!

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.delegate = self
        cView.dataSource = self
        cView.backgroundColor = .white
        cView.register(VideoCell.self, forCellWithReuseIdentifier: _videoCell)
        cView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: _videoCell)

        return cView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        populateVideoArray()
        self.setupView()
    }
    
    func populateVideoArray() {
//        let myVideo:Video = Video()
        let myVideo = Video()
        myVideo.channel = nil
        myVideo.title = "Florence + the Machine - Cosmic Love"
        myVideo.videoUrl = "videoUrl"
        myVideo.views = 9409201
        
        for _ in 1...13 {
            self.dataSource.append(myVideo)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .lightGray
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        addConstraintsWithFormat(format:"H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format:"V:|[v0]|", views: collectionView)
        
        let safeAreaToScroll = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            + 42
        
        collectionView.contentInset = UIEdgeInsets(top: safeAreaToScroll, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: safeAreaToScroll, left: 0, bottom: 0, right: 0)
        
        collectionView.bounces = false

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _videoCell, for: indexPath) as! VideoCell

        let videoRef = self.dataSource[indexPath.row]
        cell.videoTitle?.text = videoRef.title
        cell.views_count?.text = "- \(videoRef.views!) Views"
        cell.channelName?.text = "VEVO"
        cell.backgroundColor = .white
        cell.videoThumbnail = UIImageView(image: UIImage(named: "florence_placeholder"))
        
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.cornerRadius = (cell.profileImage.frame.height + cell.profileImage.frame.width) / 4
        cell.profileImage.image = UIImage(named: "florence_thumbnail")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (window?.frame.width)!, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayVideo(self.dataSource[indexPath.row])
    }
    
    func displayVideo(_ video: Video) {
        videoDisplayDelegator.displayVideo(video)
    
    }
    
    @objc func swopeDownView(_ sender: UISwipeGestureRecognizer) {
        print("wot")
    }
    
    func couldNotPlayVideo() {
        let alert = UIAlertController(title: "Error", message: "Video could not be played", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.show(self.controller!, sender: nil)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func errorOcurred() {
        couldNotPlayVideo()
    }
}
