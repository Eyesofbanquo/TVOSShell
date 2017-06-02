//
//  ScrollMainViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/15/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ScrollMainViewController: UIViewController {
    
    static let storyboard_id:String = "main_screen"
    
    @IBOutlet weak var _topFeaturedView:TopFeaturedView!
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _backgroundImage:UIImageView!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    var authenticated:Bool!
    let numberOfScrollViewPages:CGFloat! = 3.0
    let collectionView_cell_name:String = "video_cell"
    
    var imageCache:NSCache<NSString, UIImage>!
    
    var featuredVideos:[UIImage?]!
    
    var urlSession:URLSession!
    
    var viewmodel:VM! //Injectable
    var ij:InnerJoint! //Injectable
    
    var loadDataOperationQueue:OperationQueue!
    
    
    var categories:[DataStore.Category]! //Injectable
    
    
    lazy var modelCount:Int = {
        if let categories = self.ij.categories {
            return 2 + categories.count
        } else {
            return 2
        }
        //return 2 + self.categories.count
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove the items that came before this view
        var removableIndices:[Int] = []
        if let controllers = navigationController?.viewControllers {
            for (index, views) in controllers.enumerated() {
                if !(views is ScrollMainViewController) {
                    removableIndices.append(index)
                    //navigationController?.viewControllers.remove(at: index)
                }
            }
        }
        for i in removableIndices {
            self.navigationController?.viewControllers.remove(at: i)
        }
        
        //self.ij = InnerJoint()
        //self.ij.categories = self.categories
        
        //Configure the collection view
        self._collectionView.delegate = self
        self._collectionView.dataSource = self
        self._collectionView.remembersLastFocusedIndexPath = true

        //Create the background blur effect
        let blurEffect:UIBlurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self._backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._backgroundImage.addSubview(blurEffectView)
        
        
        //Testing purposes
        let url = URL(string: "https://stage-swatv.wieck.com/api/v1/authenticate")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let json:[String:Any] = ["email":"markim@wieck.com","password":"test"]
        let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        urlRequest.httpBody = body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //Set up the image cache to store the images loaded from the API
        self.imageCache = NSCache()
        
        //Create operation queue for queuing array cleaning
        self.loadDataOperationQueue = OperationQueue()

        self.authenticated = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authenticated {
            //self.loadData(query: "featured")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //When hitting a memory warning just remove all cached objects
        self.imageCache.removeAllObjects()
    }
    
    /* The title/featured image should change its image based on which item is currently focused in the collection view. This will be done by casting the nextFocusedView as a VideoCell and ravaging its positionInCollectionView property to determine which Cell was actually focused. Then you display its featured image */
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        //If the next cell is a videocell then set the featured image to be the same as the video cell image
        guard let video_cell = context.nextFocusedView as? VideoCell else { return }
        self._topFeaturedView.featuredImageView.image = video_cell._videoImage.image

        guard let previous_video_cell = context.previouslyFocusedView as? VideoCell else { return }
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.22, animations: {
            self._topFeaturedView.layer.opacity = 0.0
        })
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.22, animations: {
            self._topFeaturedView.layer.opacity = 1.0
            
        })
        
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self._collectionView]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

extension ScrollMainViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionView_cell_name, for: indexPath) as? VideoCell else { return UICollectionViewCell() }
        
        /*Overrode this function to add the ability to reset the cell exactly how I want to */
        videoCell.prepareForReuse()
        
        var imageName:NSString
        
        /* First check to see if image cache exists. If not, then create UIImage from the imageName and store the UIImage in the cache. If it does exist then just use the image cache for the video cell's imageview */
        switch indexPath.item {
        case 0:
            imageName = "search_icon"
            if self.imageCache.object(forKey: imageName) == nil {
                let toBeCachedImage:UIImage? = UIImage(named: imageName as String)
                self.imageCache.setObject(toBeCachedImage!, forKey: imageName)
            }
            videoCell._videoImage.image = self.imageCache.object(forKey: imageName)
            videoCell._videoTitle.text = "Search"
        case self.modelCount - 1:
            imageName = "settings"
            if self.imageCache.object(forKey: imageName) == nil {
                let toBeCachedImage:UIImage? = UIImage(named: imageName as String)
                self.imageCache.setObject(toBeCachedImage!, forKey: imageName)
            }
            videoCell._videoImage.image = self.imageCache.object(forKey: imageName)
            videoCell._videoTitle.text = "Settings"
        default:
            if let categories = self.ij.categories {
                videoCell._videoTitle.text = categories[indexPath.item - 1].rawValue
                switch categories[indexPath.item - 1] {
                case .featured:
                    //If the image doesn't exist in cache then download and store in cache else load from cache
                    if self.imageCache.object(forKey: DataStore.Category.featured.rawValue as NSString) == nil {
                        if let firstThumbnailInCategory = self.ij.firstItem(in: .featured, with: .main)?.thumbnailUri {
                            Alamofire.request(firstThumbnailInCategory).responseData {
                                response in
                                guard let data = response.data else { return }
                                let image:UIImage? = UIImage(data: data)
                                self.imageCache.setObject(image!, forKey: DataStore.Category.featured.rawValue as NSString)
                                videoCell._videoImage.image = image
                            }
                        }
                    } else {
                        videoCell._videoImage.image = self.imageCache.object(forKey: DataStore.Category.featured.rawValue as NSString)
                    }
                case .b_roll:
                    print(self.ij.data(for: .b_roll))
                    //If the image doesn't exist in cache then download and store in cache else load from cache
                    if self.imageCache.object(forKey: DataStore.Category.b_roll.rawValue as NSString) == nil {
                        if let firstThumbnailInCategory = self.ij.firstItem(in: .b_roll, with: .featured)?.thumbnailUri {
                            Alamofire.request(firstThumbnailInCategory).responseData {
                                response in
                                guard let data = response.data else { return }
                                let image:UIImage? = UIImage(data: data)
                                self.imageCache.setObject(image!, forKey: DataStore.Category.b_roll.rawValue as NSString)
                                videoCell._videoImage.image = image
                            }
                        }
                    } else {
                        videoCell._videoImage.image = self.imageCache.object(forKey: DataStore.Category.b_roll.rawValue as NSString)
                    }
                    
                default: break
                }
            }
        }
        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /* grab the current cell and the Storyboard instance since we will be using this Storyboard instance to create a SearchViewController from our Main Storyboard */
        let currentCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionView_cell_name, for: indexPath) as! VideoCell
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.item {
        case 0:
            /* Create and push a UISearchController to the screen. This seems to just dim the View Controller beneath it instead of pushing a new View Controller. This is by design since the UITransitionView wasn't dismissing itself when returning from the UISearchControllerContainerView */
            let resultsController:SearchViewController = SearchViewController()
        
            let searchController:UISearchController = UISearchController(searchResultsController: resultsController)
            
            searchController.searchResultsUpdater = resultsController
            searchController.obscuresBackgroundDuringPresentation = true
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.searchBarStyle = .minimal
            searchController.searchBar.keyboardAppearance = .dark
            
            resultsController.searchController = searchController
            //resultsController.viewmodel = ViewModel()
            resultsController.ij = InnerJoint()
            //resultsController.viewmodel?.copyData(self.viewmodel)

            self.present(searchController, animated: true, completion: nil)
            break
        case self.modelCount - 1:
            /* The last item in the list should be the settings item which will allow the user to log in and out of the tvOS app. Logging in and out should only be used for switching users and not to maintain multiple accounts for the same user */
            let alertController:UIAlertController = UIAlertController(title: "Logout?", message: "Would You Like To Logout?", preferredStyle: .alert)
            let confirmButton:UIAlertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(confirmButton)
            let cancelButton:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelButton)
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            let destination:FeaturedTableViewController = storyboard.instantiateViewController(withIdentifier: FeaturedTableViewController.storyboardid) as! FeaturedTableViewController
            //print(self.categories[indexPath.item - 1])
            if let categories = self.ij.categories {
                let currentCategory = categories[indexPath.item - 1]
                switch currentCategory {
                case .featured:
                    destination.category = .featured
                    destination.subcategories = [.main, .instruction_video]
                    destination.videos = ij.data(for: .featured)
                case .b_roll:
                    destination.category = .b_roll
                    destination.subcategories = [.featured]
                    destination.videos = ij.data(for: .featured)
                default: break
                }
            }
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            print("at the 2nd item in the list")
        }
    }

}

extension ScrollMainViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelCount
    }
}

extension ScrollMainViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 20, bottom: 0, right: 0)
    }
}
