//
//  FeaturedTableViewCell.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView:UICollectionView!
  
  var currentRow:Int!
  
  var collectionViewOffset:CGFloat {
    get {
      return self.collectionView.contentOffset.x
    }
    
    set {
      collectionView.contentOffset.x = newValue
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.collectionView.remembersLastFocusedIndexPath = false
  }
  
  /* This function is used for setting up the UICollectionView by supplying
   1. Delegate
   2. DataSource
   3. Row: The UITableView row this UICollectionView is placed in.
   */
  func setupCollectionView<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate:D?, row:Int){
    guard let _d = delegate else { return }
    
    self.collectionView.dataSource = _d
    self.collectionView.delegate = _d
    self.currentRow = row
    self.collectionView.tag = self.currentRow
    self.collectionView.reloadData()
  }
}
