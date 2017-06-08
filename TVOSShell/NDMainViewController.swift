//
//  NDMainViewController.swift
//  TVOSShell
//
//  Created by Markim on 6/6/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDMainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var modelCount: Int = {
    return 2
  }()
  
  var modelColors: [[UIColor]] = generateRandomData()
  
  var currentTopCollectionViewRow: Int!
  
  var initialTopFrame:CGRect!
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [tableView]
  }
  
  var previousRow:Int!
  var currentRow:Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.sectionFooterHeight = 0.0
    tableView.rowHeight = 284.0
    
    //currentTopCollectionViewRow = 0
    
    //register the header view
    let nib = UINib(nibName: "NDHeaderView", bundle: nil)
    tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}



extension NDMainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let currentCell = cell as? NDMainTableViewCell else { return }
    currentCell.setup(delegate: self, at: indexPath.section)
    //cell.initialize(delegate: self, at: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
    //only returning 1-3 since at the ends the indexPath guard statement will exit this function
    
    
    if context.focusHeading == .down {
      
      guard let pIndexPath = context.previouslyFocusedIndexPath,
        let nIndexPath = context.nextFocusedIndexPath
        else { return }
      previousRow = pIndexPath.section
      currentRow = nIndexPath.section
      
      //print(previousRow)
      print("current row: \(currentRow) and previous row: \(previousRow)")
      //When focusHeading down then the currentRow will be what you're going to while the previous row is what's above
      
      let previousCell = tableView.cellForRow(at: pIndexPath)
      let previousHeader = tableView.headerView(forSection: pIndexPath.section)
      let nextCell = tableView.cellForRow(at: nIndexPath)
      
      if initialTopFrame == nil {
        initialTopFrame = tableView.convert(previousCell!.frame, to: tableView.superview)
      }
      
      coordinator.addCoordinatedAnimations({
        //previousCell?.alpha = 0.5
        //previousHeader?.alpha = 0.5
      }, completion: {
        //nextCell?.frame = self.initialTopFrame
        //nextCell?.frame = previousCell!.frame
      })
      //tableView.deque
    }
    
    //Focus heading up means current row = above row and previous row = below row
    
  }
  
  /* Disable tableview focusing in favor for focusing on collectionview items inside each tableview row */
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    /*guard let toRow = currentTopCollectionViewRow else { return 600.0 }
     //print(indexPath.section)
     
     //The top row number that is returned is the collectionView.tag of the UICollectionViewCEll you're currently going to. This section is the section you want to be at 600.0. Every other section should be at 284.0
     if toRow == indexPath.section {
     print(indexPath.section)
     return 600.0
     }
     /*if toRow != indexPath.section {
     return 284.0
     }*/
     return 284.0*/
    return 284.0
  }
  
}

extension NDMainViewController: UITableViewDataSource {
  /* Return 1 which means each section can only have 1 row */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  /* You control the number of rows total by controlling the number of sections = categories in the app */
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "nd_category_cell", for: indexPath) as? NDMainTableViewCell else { return UITableViewCell() }
    cell.prepareForReuse()
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
    let header = cell as! NDHeader
    header.titleLabel.text = "Category Name"
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100.0
  }
  
  
}

extension NDMainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nd_main_collection_view_cell", for: indexPath) as! NDMainCollectionViewCell
    
    cell.backgroundColor = modelColors[collectionView.tag][indexPath.item]
    cell.currentRow = collectionView.tag
    cell.delegate = self
    
    return cell
  }
}

extension NDMainViewController: UICollectionViewDelegate {
}

extension NDMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: -150.0, left: 20.0, bottom: 0.0, right: 20.0)
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 30.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 40.0
  }
}
