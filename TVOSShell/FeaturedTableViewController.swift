//
//  FeaturedTableViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FeaturedTableViewController: UIViewController {
  
  fileprivate let featured_cell:String = "featured_cell"
  static let storyboardid:String = "featuredviewcontroller"
  fileprivate let featured_cell_segue:String = "featured_cell_segue"
  
  @IBOutlet weak var _tableView:UITableView!
  
  let model:[[UIColor]] = [[UIColor.red, UIColor.black, UIColor.blue,UIColor.red, UIColor.black, UIColor.blue,UIColor.red, UIColor.black, UIColor.blue],[UIColor.red, UIColor.black, UIColor.blue],[UIColor.red, UIColor.black, UIColor.blue]]
  
  //Inject the values for these variables
  var videos:[[Video]]!
  var subcategories:[SubCategory]!
  var category:DataStore.Category!
  
  let categorySectionHeaders:[String] = ["Featured", "Your Videos 1", "Your Videos 2"]
  
  var imageCache:NSCache<NSString, UIImage>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    //Assign this viewcontrolelr as the delegate and datasource for its UITableView
    self._tableView.delegate = self
    self._tableView.dataSource = self
    self._tableView.remembersLastFocusedIndexPath = false
    
    self.imageCache = NSCache()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    self.imageCache.removeAllObjects()
  }
  
  /* Disable tableview focusing in favor for focusing on collectionview items inside each tableview row */
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  
}

/* Extension for UITableView delegation */
extension FeaturedTableViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    /* Before the tableview displays its cell make sure to set up the collectionview that it contains*/
    
    /* call .setup(:delegate,:datasource) */
    guard let currentCell = cell as? FeaturedTableViewCell else { return }
    
    /* Pass in the indexPath.section for the row since the UITableView is sectioned by sectiosn that each contain 1 row */
    currentCell.setupCollectionView(delegate: self, row: indexPath.section)
    
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //return section == 0 ? "" : self.categorySectionHeaders[section]
    return self.subcategories[section].rawValue
    // return self.categorySectionHeaders[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: featured_cell, for: indexPath) as? FeaturedTableViewCell else { return UITableViewCell() }
    
    return cell
  }
  
}

/* Extension for UITableView datasource */
extension FeaturedTableViewController: UITableViewDataSource {
  /* The number of rows in each section will be 1 while the array of array of data objects will be used to determine how many sections there will be. This is so that you can have a section header for each UITableView row cell */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.subcategories.count
  }
}

/* Extensions for UICollectionView */
extension FeaturedTableViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.videos[collectionView.tag].count
  }
  
  
}

extension FeaturedTableViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featured_cell, for: indexPath) as? FeaturedCollectionViewCell else { return UICollectionViewCell() }
    //cell.backgroundColor = model[collectionView.tag][indexPath.item]
    
    //load the image data
    let urlString = self.videos[collectionView.tag][indexPath.item].thumbnailUri
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!) {
      data, response, error in
      guard let data = data else { return }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        cell.imageView.image = image
      }
      }.resume()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let destination:VideoDetailViewController = storyboard.instantiateViewController(withIdentifier: VideoDetailViewController.storyboard_id) as! VideoDetailViewController
    let urlString = "https://stage-swatv.wieck.com/api/v1/videos/\(self.videos[collectionView.tag][indexPath.item].id)/720p"
    
    var urlComponents:URLComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/videos/\(self.videos[collectionView.tag][indexPath.item].id)"
    let videoURL = urlComponents.url!
    
    destination.video = self.videos[collectionView.tag][indexPath.item]
    Alamofire.request(urlComponents).responseJSON(completionHandler: {
      response in
      switch response.result {
      case .success(_):
        let json = JSON(data: response.data!)
        let downloads = json["downloads"]
        if downloads["source"] != JSON.null {
          destination.videoURLString = downloads["source"]["uri"].stringValue
        } else if downloads["720p"] != JSON.null {
          destination.videoURLString = downloads["720p"]["uri"].stringValue
        }
        self.present(destination, animated: true, completion: nil)
      case .failure(_):
        break
      }
    })
    
  }
}

extension FeaturedTableViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag != 0 {
      return CGSize(width: 400.0, height: 400.0)
    }
    return CGSize(width: 640.0, height: 400.0)
  }
}
