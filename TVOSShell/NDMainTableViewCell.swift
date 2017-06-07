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
  
  func setup<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: D?, at row: Int){
    guard let d = delegate else { return }
    collectionView.dataSource = d
    collectionView.delegate = d
    collectionView.tag = row
    
    let nib = UINib(nibName: "NDMainCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "nd_main_collection_view_cell")
    
    collectionView.reloadData()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [collectionView]
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
