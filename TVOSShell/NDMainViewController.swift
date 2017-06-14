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
  @IBOutlet weak var favoritesButton: UIIconLabel!
  @IBOutlet weak var searchButton: UIIconLabel!
  @IBOutlet weak var settingsButton: UIIconLabel!
  @IBOutlet weak var swaLogo: UIImageView!
  
  var tableViewTopConstraint: NSLayoutConstraint!
  var tableViewScrolledTopConstraint: NSLayoutConstraint!
  
  
  
  
  var modelColors: [[UIColor]] = generateRandomData()
  
  var previousTableViewOrigin: CGPoint = CGPoint.zero
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [tableView]
  }
  
  var hiddenRows: [Int]!
  
  var focusGuide: UIFocusGuide!
  var shrinkCell: Bool!

  //For the top bar navigation that holds the SWA logo and 3 buttons
  var topBarFocusGuide: UIFocusGuide!
  var topBarItems: [UIView]!
  
  var ij: InnerJoint!
  
  var previousIndexPath: IndexPath!
  var nextIndexPath: IndexPath!
  
  var modelCount: Int {
    return 5
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Remove the items that came before this view
    var removableIndices:[Int] = []
    if let controllers = navigationController?.viewControllers {
      for (index, views) in controllers.enumerated() {
        if !(views is NDMainViewController) {
          removableIndices.append(index)
          //navigationController?.viewControllers.remove(at: index)
        }
      }
    }
    for i in removableIndices {
      self.navigationController?.viewControllers.remove(at: i)
    }
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.sectionFooterHeight = 1.0
    
    //register the header view
    let nib = UINib(nibName: "NDHeaderView", bundle: nil)
    tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    
    topBarItems = [favoritesButton, settingsButton, searchButton, swaLogo]
    
    tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 156)
    tableViewTopConstraint.isActive = true
    //hiddenRows = []
    
    tableView.delegate = self
    
    
    //searchButton.target(forAction: #selector(NDMainViewController.random(_:)), withSender: self)
    let searchTap = UITapGestureRecognizer(target: self, action: #selector(NDMainViewController.loadSearchController(_:)))
    searchButton.addGestureRecognizer(searchTap)
    
    let favoritesTap = UITapGestureRecognizer(target: self, action: #selector(NDMainViewController.loadFavoritesController(_:)))
    favoritesButton.addGestureRecognizer(favoritesTap)
    
    let settingsTap = UITapGestureRecognizer(target: self, action: #selector(NDMainViewController.loadSettingsController(_:)))
    settingsButton.addGestureRecognizer(settingsTap)
    
    //Load the videos from the API. This is temporary atm
    print(ij.allData)
  }

  
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    focusGuide = UIFocusGuide()
    self.view.addLayoutGuide(focusGuide)
    
    focusGuide.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    focusGuide.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    focusGuide.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    focusGuide.isEnabled = false
    
    //This focus guide will allow the user to go from the tableview to the top bar and back
    topBarFocusGuide = UIFocusGuide()
    view.addLayoutGuide(topBarFocusGuide)
    topBarFocusGuide.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    topBarFocusGuide.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    topBarFocusGuide.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
    topBarFocusGuide.preferredFocusEnvironments = [favoritesButton]
    
    tableViewScrolledTopConstraint = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80)
    
    //tableView.topAnchor = tableViewTopConstraint
    /*Winona.dispatchGroup.notify(queue: .main, execute: {
      print("jobs have been completed")
    })*/
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocus(in: context, with: coordinator)
    
    if context.focusHeading == .down {
      if context.previouslyFocusedView is UIIconLabel {
        topBarFocusGuide.preferredFocusEnvironments = [tableView]
      }
    }
    
    //If the previous focus item is a collectionviewcell and the next item is not then that means you've hit the focus guide and you should reset the preferredfocusenvironments
    if context.focusHeading == .up {
      if let previouslyFocusedView = context.previouslyFocusedView as? UICollectionViewCell {
        if !(context.nextFocusedView! is UICollectionViewCell) {
          topBarFocusGuide.preferredFocusEnvironments = [favoritesButton]
        }
        //Do this because the preferredFocusEnvironments is still going to be the tableview so once you hit this focusguide the next focusedView will be the tableview which will return a UICollectionViewCell (basically you're locked in the tableview). So you check to see if the nextFocusedView is a CollectionCell and if it is then set the preferredfocusenvironments to the favoritesbutton
        if context.nextFocusedView! is UICollectionViewCell {
          topBarFocusGuide.preferredFocusEnvironments = [favoritesButton]
        }
      }
    }
  }
  
}



extension NDMainViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let currentCell = cell as? NDMainTableViewCell else { return }
    currentCell.setup(delegate: self, at: indexPath.section)
  }
  
  func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if context.focusHeading == .up {
      
      if let nextIndexPath = context.nextFocusedIndexPath, let previousIndexPath = context.previouslyFocusedIndexPath {
        
        //Bring the top bar back
        if nextIndexPath.section == 0 {
          topBarFocusGuide.isEnabled = true
          coordinator.addCoordinatedAnimations({
            for view in self.topBarItems {
              if view is UIIconLabel {
                view.alpha = 0.5
              } else {
                view.alpha = 1.0
              }
            }
          }, completion: {
            //self.tableViewTopConstraint.isActive = true
            //self.tableViewScrolledTopConstraint.isActive = false
          })
        }
        
        //Used for the scrollview delegate
        self.previousIndexPath = previousIndexPath
        self.nextIndexPath = nextIndexPath
      }
    }
    
    if context.focusHeading == .down {
      if let nextIndexPath = context.nextFocusedIndexPath, let previousIndexPath = context.previouslyFocusedIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? NDMainTableViewCell, let nextCell = tableView.cellForRow(at: nextIndexPath) as? NDMainTableViewCell, let previousHeader = tableView.headerView(forSection: previousIndexPath.section), let nextHeader = tableView.headerView(forSection: nextIndexPath.section) {
        
        //On the first step going down make sure you hide the top bar. ANimate it up
        if nextIndexPath.section == 1 {
          topBarFocusGuide.isEnabled = false

          coordinator.addCoordinatedAnimations({
            for view in self.topBarItems {
              if view is UIIconLabel {
                view.alpha = 0.0
              }
            }
          }, completion: {
            //self.tableViewTopConstraint.isActive = false
            //self.tableViewScrolledTopConstraint.isActive = true
          })
        }
        
        //Used for the scrollview delegate
        self.previousIndexPath = previousIndexPath
        self.nextIndexPath = nextIndexPath
      }
    }
  }
  
  /* Disable tableview focusing in favor for focusing on collectionview items inside each tableview row */
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 700
  }
  
}

extension NDMainViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    
  }
}

extension NDMainViewController: UITableViewDataSource {
  /* Return 1 which means each section can only have 1 row */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  /* You control the number of rows total by controlling the number of sections = categories in the app */
  func numberOfSections(in tableView: UITableView) -> Int {
    return modelCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "nd_category_cell", for: indexPath) as? NDMainTableViewCell else { return UITableViewCell() }
    
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
    cell.backgroundColor = .clear
    //cell.backgroundColor = modelColors[collectionView.tag][indexPath.item]
    //cell.currentRow = collectionView.tag
    //cell.delegate = self
    
    return cell
  }
  
  /* Present the video player when the user selects a video. Make sure to send a video object to the video player */
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "New_Design", bundle: nil)
    let videoPlayerController = storyboard.instantiateViewController(withIdentifier: "video_player") as! NDVideoPlayerViewController
    self.present(videoPlayerController, animated: true, completion: nil)
  }
}

extension NDMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 20.0)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 30.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20.0
  }
}

extension NDMainViewController: UIScrollViewDelegate {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    //print(targetContentOffset.pointee)
    
    let indexPath = tableView.indexPathForRow(at: targetContentOffset.pointee)
    guard let index = indexPath else { return }
    
    targetContentOffset.pointee = tableView.rectForHeader(inSection: index.section).origin
    
    if index.section == previousIndexPath.section {
      targetContentOffset.pointee = tableView.rectForHeader(inSection: nextIndexPath.section).origin
      //targetContentOffset.pointee.y = targetContentOffset.pointee.y - 100

    }
  }
}

extension NDMainViewController {
  
  func loadSearchController(_ sender: UITapGestureRecognizer) {
    //print("load search")
    let resultsController:SearchViewController = SearchViewController()
    
    let searchController:UISearchController = UISearchController(searchResultsController: resultsController)
    
    searchController.searchResultsUpdater = resultsController
    searchController.obscuresBackgroundDuringPresentation = true
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchBar.keyboardAppearance = .dark
    
    resultsController.searchController = searchController
    resultsController.ij = InnerJoint()
    
    self.present(searchController, animated: true, completion: nil)
  }
  
  func loadFavoritesController(_ sender: UITapGestureRecognizer) {
    
  }
  
  func loadSettingsController(_ sender: UITapGestureRecognizer) {
    
  }
}
