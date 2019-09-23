//
//  ViewController.swift
//  faketube
//
//  Created by Daniel Freitas on 14/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit

enum pageTitles: String {
    case home = "Home"
    case trending = "Trending"
    case subs = "Subscriptions"
    case account = "My Account"
}

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout, VideoDisplayDelegate, ErrorOnDisplayVideo {

    func displayVideo(_ video: Video) {
//        let videoPlayerLauncher = VideoLauncherController()
//        videoPlayerLauncher.videoToDisplay = video
//        videoPlayerLauncher.errorDetectionDelegate = self
//
//        self.navigationController?.pushViewController(videoPlayerLauncher, animated: true)
        let videoPlayer = VideoPlayerViewController()
        
        videoPlayer.video = video
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
    var mainCollectionViews: UICollectionView?
    
    let _pageAsCell = "pageAsHomeCell"
    let _homePageAsCell = "homePageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        setupCollectionViews()
        
    }
    
    @objc func myMethod(_ sender: UISwipeGestureRecognizer) {
        print("Swope down")
    }
    
    lazy var menuBar: MenuBar = {
       let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    func setupMainView() {
        view.backgroundColor = .white

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .redMain
        navigationController?.navigationBar.shadowImage = UIImage()
        let titleMenuView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleMenuView.text = "  Home"
        titleMenuView.font = .boldSystemFont(ofSize: 20)
        titleMenuView.textColor = .white
        
        navigationItem.titleView = titleMenuView

        print("NavBarSpace:", navigationController?.navigationBar.frame.height)
//
//        let magnifierIcon = UIImage(named: "")
//        magnifierIcon?.withRenderingMode(.alwaysOriginal)
        
        let optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(openMenuActionDispatched))
        optionsButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = optionsButton
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format:"H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format:"V:[v0(50)]", views: menuBar)
        let guide = view.safeAreaLayoutGuide
        menuBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        
    }
    
    @objc func openMenuActionDispatched() {
        openActionSheet()
    }
    
    func openActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "Options", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
  
        actionSheet.addAction(UIAlertAction(title: "Action 1", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Action 2", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Action 3", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: nil))
        
        actionSheet.show(self, sender: nil)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setupCollectionViews() {
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: _pageAsCell)
        self.collectionView?.register(HomeCollectionAsCell.self, forCellWithReuseIdentifier: _homePageAsCell)
        self.collectionView?.backgroundColor = .lightGray
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.bounces = false
    }
    
    func setCollectionViewPage(index: Int) {
        self.collectionView?.setContentOffset(CGPoint(x: CGFloat(index) * (view.frame.width), y: 0), animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: _homePageAsCell, for: indexPath) as! HomeCollectionAsCell

        pageCell.videoDisplayDelegator = self
        pageCell.controller = self
        return pageCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height + view.safeAreaInsets.bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexResolution = scrollView.contentOffset.x / view.frame.width
        menuBar.animateSlideBar(toOffset: Float(indexResolution))
        menuBar.selectMenuItem(index: Int(indexResolution))
        setTabTitle(index: Int(indexResolution))
    }
    
    func setTabTitle(index: Int) {
        var title: pageTitles
        switch(index) {
            case 0: title = .home; break
            case 1: title = .trending; break
            case 2: title = .subs; break
            case 3: title = .account; break
            default : title = .home
        }
        
        let titleMenuView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleMenuView.text = "      " + title.rawValue
        titleMenuView.font = .boldSystemFont(ofSize: 20)
        titleMenuView.textColor = .white
        
        navigationItem.titleView = titleMenuView
    }
    
    func couldNotPlayVideo() {
        let alert = UIAlertController(title: "Error", message: "Video could not be played", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.show(self, sender: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorOcurred() {
        couldNotPlayVideo()
    }
}


