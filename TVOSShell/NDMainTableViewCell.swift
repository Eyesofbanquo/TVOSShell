//
//  NDMainTableViewCell.swift
//  TVOSShell
//
//  Created by Markim on 6/6/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDMainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView:UICollectionView!
  
  override func awakeFromNib() {
    print("awoken")
  }
  
  func setup<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: D?, at row: Int){
    guard let d = delegate else { return }
    collectionView.dataSource = d
    collectionView.delegate = d
    collectionView.tag = row
    
    /*let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 567.0, height: 364.0)
    flowLayout.minimumLineSpacing = 20.0
    flowLayout.minimumInteritemSpacing = 150
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0.0, right: 50.0)
    flowLayout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = flowLayout*/
    
    
    let nib = UINib(nibName: "NDMainCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "nd_main_collection_view_cell")
    collectionView.remembersLastFocusedIndexPath = true
    //collectionView.remembersLastFocusedIndexPath = true
    //collectionView.sp
    collectionView.reloadData()
  }
  
  override func prepareForReuse() {
    self.alpha = 1.0
    self.contentView.alpha = 1.0
  }
  
  func applyFocusChanges(opacity: CGFloat) {
    self.alpha = opacity
    self.contentView.alpha = opacity
    //self.isHidden = true
  }
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [collectionView]
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  
}
