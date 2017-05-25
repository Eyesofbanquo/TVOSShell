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
    
    var collectionView:UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Create the flowlayout
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.itemSize = CGSize(width: 375.0, height: 250.0)
        flowLayout.minimumLineSpacing = CGFloat(integerLiteral: 50)
        flowLayout.minimumInteritemSpacing = CGFloat(integerLiteral: 50)
        
        //Create the collectionView for the bottom bar navigation
        self.collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: flowLayout)
        
    }

}


extension VideoBottomBarNavigation: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
        
    }
}

extension VideoBottomBarNavigation: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
}
