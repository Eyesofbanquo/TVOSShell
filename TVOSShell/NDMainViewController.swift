//
//  NDMainViewController.swift
//  TVOSShell
//
//  Created by Markim on 6/6/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NDMainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var favoritesButton: UIIconLabel!
  @IBOutlet weak var searchButton: UIIconLabel!
  @IBOutlet weak var settingsButton: UIIconLabel!
  @IBOutlet weak var swaLogo: UIImageView!
  
  var tableViewTopConstraint: NSLayoutConstraint!
  var tableViewScrolledTopConstraint: NSLayoutConstraint!
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [tableView]
  }
  
  //var hiddenRows: [Int]!
  
  var focusGuide: UIFocusGuide!
  //var shrinkCell: Bool!

  //For the top bar navigation that holds the SWA logo and 3 buttons
  var topBarFocusGuide: UIFocusGuide!
  var topBarItems: [UIView]!
  
  var ij: InnerJoint!
  
  var previousIndexPath: IndexPath!
  var nextIndexPath: IndexPath!
  
  var modelCount: Int {
    guard let categories = ij.categories else { return 0 }
    return categories.count
  }
  
  var categoryNames: [String] = ["Gary's Takeoff", "Safety and Security", "Work Perks", "Office Space", "Extra Mile", "Around Our SysteM"]
  
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
    //print(ij.allData)
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
    if let categories = ij.categories {
      return categories.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "nd_category_cell", for: indexPath) as? NDMainTableViewCell else { return UITableViewCell() }
    
    
    
    //cell.prepareForReuse()
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
    
    let header = cell as! NDHeader
    header.titleLabel.text = categoryNames[section].uppercased()
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100.0
  }
}

extension NDMainViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ij.data(atRow: collectionView.tag).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nd_main_collection_view_cell", for: indexPath) as! NDMainCollectionViewCell
    cell.backgroundColor = .clear
    //cell.backgroundColor = modelColors[collectionView.tag][indexPath.item]
    //cell.currentRow = collectionView.tag
    //cell.delegate = self
    cell.prepareForReuse()
    
    let urlString = ij.data(atRow: collectionView.tag)[indexPath.item].thumbnailUri
    let url = URL(string: urlString)
    /*URLSession.shared.dataTask(with: url!) {
      data, response, error in
      guard let data = data else { return }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        cell.imageView.image = image
      }
      }.resume()*/
    
    let id = ij.data(atRow: collectionView.tag)[indexPath.item].id
    
    var urlComponents:URLComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/videos/\(id)"
    
    
    Alamofire.request(urlComponents).responseJSON(completionHandler: {
      response in
      switch response.result {
        
      case .success(_):
        let json = JSON(data: response.data!)
        //print(json)
        var videoURLString: String
        videoURLString = json["downloads"]["720p"]["uri"].stringValue
        
        // MARK: Get the date the video was actually created - uncomment below
        
        //let authorAtString = json["source"]["authoredAt"].stringValue
        //print(authorAtString)
        /*if var swa = self.ij.data(atRow: collectionView.tag)[indexPath.item] as? SWAVideo {
          swa.set(authoredDate: authorAtString, instead: true)
        }*/
        
        let index = videoURLString.index(videoURLString.startIndex, offsetBy: 88)
        let thumbnailString = videoURLString.substring(to: index) + ".jpg"
        
        
        let url = URL(string: thumbnailString)
        URLSession.shared.dataTask(with: url!) {
          data, response, error in
          guard let data = data else { return }
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            cell.imageView.image = image
          }
          }.resume()
        
      case .failure(_):
        break
      }
    })
    
    let duration = ij.data(atRow: collectionView.tag)[indexPath.item].getTime().minutes
    let seconds = ij.data(atRow: collectionView.tag)[indexPath.item].getTime().seconds
    
    if duration == 1 {
      cell.duration.text = "\(duration) min"
    } else if duration > 1{
      cell.duration.text = "\(duration) mins"
    } else {
      cell.duration.text = "\(seconds) s"
    }
    
    return cell
  }
  
  /* Present the video player when the user selects a video. Make sure to send a video object to the video player */
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "New_Design", bundle: nil)
    let videoPlayerController = storyboard.instantiateViewController(withIdentifier: "video_player") as! NDVideoPlayerViewController
    
    let cell = collectionView.cellForItem(at: indexPath) as! NDMainCollectionViewCell
    
    //let time: (Int, Int) = ij.data(atRow: collectionView.tag)[indexPath.item].getTime()
    //videoPlayerController.time = time
    videoPlayerController.video = ij.data(atRow: collectionView.tag)[indexPath.item]
    
    if let image = cell.imageView.image {
      
      /* Set a gradient on the image in the background */
      let gradientLayer:CAGradientLayer = CAGradientLayer()
      gradientLayer.frame = self.view.bounds
      gradientLayer.colors = [
        UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).cgColor,
        UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor]
      gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
      //self.backgroundImage.layer.mask = gradientLayer
      
      //Set up the visual for the video player controller
      self.present(videoPlayerController, animated: true, completion: {
        videoPlayerController.backgroundImage.alpha = 0.0
        videoPlayerController.backgroundImage.image = image
        videoPlayerController.backgroundImage.layer.mask = gradientLayer
        
        UIView.animate(withDuration: 3.0, animations: {
          videoPlayerController.backgroundImage.alpha = 1.0
          
        })
      })
    }
    
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
    
    
    let indexPath = tableView.indexPathForRow(at: targetContentOffset.pointee)
    guard let index = indexPath else { return }
    
    targetContentOffset.pointee = tableView.rectForHeader(inSection: index.section).origin
    
    if index.section == previousIndexPath.section {
      targetContentOffset.pointee = tableView.rectForHeader(inSection: nextIndexPath.section).origin
    }
  }
}

extension NDMainViewController {
  
  func loadSearchController(_ sender: UITapGestureRecognizer) {
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
