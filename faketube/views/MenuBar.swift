//
//  MenuBar.swift
//  faketube
//
//  Created by Daniel Freitas on 16/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import UIKit
private let _menuCell = "MenuViewCell"

enum IconName: String {
    case home = "home"
    case hot = "hot"
    case subs = "feed"
    case account = "user"
    case def = "-"
}

class MenuBar: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    var homeController: MainController?
    
    var firstLoad = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupTabCollectionView()
        setupIndicatorBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.allowsSelection = true
        return cv
    }()

    func setupTabCollectionView() {
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: _menuCell)
        collectionView.register(UINib(nibName: _menuCell, bundle: nil), forCellWithReuseIdentifier: _menuCell)
        collectionView.backgroundColor = .redMain
        
        addSubview(collectionView)
        self.addConstraintsWithFormat(format:"H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat(format:"V:|[v0]|", views: collectionView)
        
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: { _ in
            self.collectionView.selectItem(at: [0,0], animated: true, scrollPosition: [])
            print("SELECT!!!!")
        })
    }
    
    func selectMenuItem(index: Int) {
        self.collectionView.selectItem(at: [0,index], animated: true, scrollPosition: [])
    }
    
    var indicatorBarLeftAnchorConstraint: NSLayoutConstraint?
    var indicatorBar = UIView()
    
    func setupIndicatorBar() {
        let frameWidth = self.widthAnchor
        indicatorBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        indicatorBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorBar)
        
        indicatorBarLeftAnchorConstraint = indicatorBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        indicatorBarLeftAnchorConstraint?.isActive = true
        
        indicatorBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicatorBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorBar.widthAnchor.constraint(equalTo: frameWidth, multiplier: 0.25).isActive = true
    }
    
    func animateSlideBar(toOffset: Float) {
        self.indicatorBarLeftAnchorConstraint?.constant = self.frame.width / 4 * CGFloat(toOffset)
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.setCollectionViewPage(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _menuCell, for: indexPath) as! MenuViewCell

        cell.backgroundColor = .redMain
        var iconName: IconName?
        
        switch (indexPath.row) {
            case 0: iconName = .home; break
            case 1: iconName = .hot; break
            case 2: iconName = .subs; break
            case 3: iconName = .account; break
            default: iconName = .def; break
        }
        
        cell.tabIcon.image = UIImage(named: iconName!.rawValue)?.withRenderingMode(.alwaysTemplate)
        cell.tabIcon.tintColor = UIColor.useRawValues(red: 80, green: 30, blue: 30)
        
        if (firstLoad) {
            firstLoad = false
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
