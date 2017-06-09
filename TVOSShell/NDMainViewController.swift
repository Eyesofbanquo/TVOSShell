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
  
  var initialTopCellFrame: CGRect!
  var initialTopHeaderFrame: CGRect!
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [tableView]
  }
  
  var previousRow:Int!
  var currentRow:Int!
  var hiddenRows: [Int]!
  var focusGuide: UIFocusGuide!
  var shrinkCell: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    //tableView.prefetchDataSource = self
    tableView.sectionFooterHeight = 0.0
    tableView.rowHeight = 284.0
    hiddenRows = []
    
    //currentTopCollectionViewRow = 0
    shrinkCell = false
    
    //register the header view
    let nib = UINib(nibName: "NDHeaderView", bundle: nil)
    tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    focusGuide = UIFocusGuide()
    self.view.addLayoutGuide(focusGuide)
    
    focusGuide.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    focusGuide.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    focusGuide.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    focusGuide.isEnabled = false
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
    
    
  }
  
  func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
    //only returning 1-3 since at the ends the indexPath guard statement will exit this function
    
    if context.focusHeading == .up {
      if let nextIndexPath = context.nextFocusedIndexPath, let nextCell = tableView.cellForRow(at: nextIndexPath) as? NDMainTableViewCell {
        //hiddenRows.popLast()
        //This section number should equal the model-count for the UITableView - 1
        if nextIndexPath.section == 3 {
          shrinkCell = false
          let indexSet: IndexSet = [nextIndexPath.section]
          tableView.reloadSections(indexSet, with: .automatic)
        }
      }
    }
    
    if context.focusHeading == .down {
      if let nextIndexPath = context.nextFocusedIndexPath, let previousIndexPath = context.previouslyFocusedIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? NDMainTableViewCell, let nextCell = tableView.cellForRow(at: nextIndexPath) as? NDMainTableViewCell, let previousHeader = tableView.headerView(forSection: previousIndexPath.section), let nextHeader = tableView.headerView(forSection: nextIndexPath.section) {
        
        //only 5 elements so you've reached the bottom when the section = 4. Enable the top focus guide to allow upward movement
        if nextIndexPath.section == 4 {
          //focusGuide.isEnabled = true
          shrinkCell = true
          let indexSet: IndexSet = [nextIndexPath.section]
          tableView.reloadSections(indexSet, with: .fade)
        }
        print(hiddenRows)
      }
    }
  }
  
  /* Disable tableview focusing in favor for focusing on collectionview items inside each tableview row */
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if shrinkCell && indexPath.section == 3 {
      //print("this row \(indexPath.section) will be hidden")
      return 284.0
    }
    return 600.0
    
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
    if hiddenRows.contains(indexPath.section) {
      //cell.contentView.alpha = 0.1
      return cell
    }
    //cell.prepareForReuse()
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
