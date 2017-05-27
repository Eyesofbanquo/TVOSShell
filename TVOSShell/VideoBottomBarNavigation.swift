//
//  VideoBottomBarNavigation.swift
//  TVOSShell
//
//  Created by Markim on 5/25/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class VideoBottomBarNavigation: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var width:CGFloat!
    var height:CGFloat!
    let searchCellId:String = "search_cell_id"
    var focusGuide:UIFocusGuide!

    
    override var canBecomeFocused: Bool {
        return true
    }
    
    var collectionView:UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Create the flowlayout
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.itemSize = CGSize(width: 375.0, height: 250.0)
        flowLayout.minimumLineSpacing = CGFloat(integerLiteral: 50)
        flowLayout.minimumInteritemSpacing = CGFloat(integerLiteral: 50)
        
        //Create a blurred background for this interactive uiview
        let blurEffect:UIBlurEffect = UIBlurEffect(style: .light)
        let imageEffectView:UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        imageEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageEffectView)
        imageEffectView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        
        //Create the collectionView for the bottom bar navigation
        self.collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: flowLayout)
        let cell:UINib = UINib(nibName: "SearchCell", bundle: nil)
        self.collectionView.register(cell, forCellWithReuseIdentifier: searchCellId)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //self.collectionView.remembersLastFocusedIndexPath = true
        
        self.isUserInteractionEnabled = true
        imageEffectView.contentView.addSubview(self.collectionView)

        self.focusGuide = UIFocusGuide()
        self.addLayoutGuide(focusGuide)

        focusGuide.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        focusGuide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        focusGuide.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        focusGuide.preferredFocusEnvironments = [self.collectionView]
        print(focusGuide)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}


extension VideoBottomBarNavigation: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchCellId, for: indexPath) as? SearchCellCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = UIColor.green
        
        return cell
        
    }
}

extension VideoBottomBarNavigation: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
