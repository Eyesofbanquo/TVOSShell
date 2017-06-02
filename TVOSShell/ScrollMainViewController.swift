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
    
    @IBOutlet weak var _topFeaturedView:TopFeaturedView!
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _backgroundImage:UIImageView!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    var authenticated:Bool!
    let numberOfScrollViewPages:CGFloat! = 3.0
    let collectionView_cell_name:String = "video_cell"
    
    var imageCache:NSCache<NSString, UIImage>!

    
    /* For testing purposes only */
    //let modelCount:Int = 5
    
    
    var featuredVideos:[UIImage?]!
    
    var urlSession:URLSession!
    
    var viewmodel:VM!
    
    var loadDataOperationQueue:OperationQueue!
    var categories:[String] = ["Featured", "B-Roll", "Instructional"]
    lazy var modelCount:Int = {
        return 2 + self.categories.count
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Configure the view model
        self.viewmodel = ViewModel()
        
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
        //

        
        /*load videos from the API*/
        /* Keep the alamofire requests */
        self.authenticated = false
        /*Alamofire.request(urlRequest).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success( _):
                //on success fire the other API request
                guard let data = response.data else { return }
                _ = JSON(data: data)
                self.authenticated = true
                
                //load the video data - possibly place this inside the viewmodel
                self.loadData(query: "featured")
                
            case .failure( _): break
                
            }
        })*/
        print(DataStore.videos[DataStore.Category.featured]?.count)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authenticated {
            //self.loadData(query: "featured")
        }
    }
    
    //Right now the query is the same as the category
    func loadData(query:String){
        //Rebuild the next URLRequest
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "stage-swatv.wieck.com"
        urlComponents.path = "/api/v1/search"
        let queryItems:[URLQueryItem] = [URLQueryItem(name: "facets", value: "{}"), URLQueryItem(name: "query", value: query), URLQueryItem(name: "types", value:"[\"video\", \"photo\"]")]
        urlComponents.queryItems = queryItems
        
        let urlRequest = URLRequest(url: urlComponents.url!)
        
        //Perform the next request to load all of the videos
        Alamofire.request(urlRequest).responseJSON(completionHandler: {
            searchResponse in
            guard let data = searchResponse.data else { return }
            let jsonResponse = JSON(data: data)   
            
            for doc in jsonResponse["docs"] {
                let object = doc.1
                
                let videoItem:Video = SWAVideo(id: object["key"]["id"].stringValue, category: .main, title: object["title"].stringValue, thumbnailUri: object["thumbnailUri"].stringValue, date: object["date"].stringValue, duration: object["duration"].doubleValue)
               // print(videoItem.thumbnailUri)
                self.viewmodel.addDataItem(item: videoItem)
                
            }
            let blockOperation:BlockOperation = BlockOperation()
            blockOperation.addExecutionBlock {
                //Scrub the view model array to rid of duplicates
                let swaArray:[SWAVideo] = Array(self.viewmodel!.data) as! [SWAVideo]
                let scrubbedSet:Set<SWAVideo> = Set(swaArray)
                let scrubbedArray:[SWAVideo] = Array(scrubbedSet)
                self.viewmodel.release()

                for item in scrubbedArray {
                    self.viewmodel.addDataItem(item: item)
                }
                
            }
            //DispatchQueue.main.async
            self.loadDataOperationQueue.addOperation(blockOperation)

            //reload the the collection view to update the thumbnails
            self._collectionView.reloadData()
            
        })
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
            //videoCell._videoImage.image = UIImage(named: "dummyimage1")
            //take the first video from the search and use that to provide an icon for the main collectionview
            var thumbnailURI:String = ""
            /*if self.viewmodel.data.count > 0 {
                switch self.viewmodel.data[indexPath.item].category[0] {
                case "featured":
                    thumbnailURI = self.viewmodel.data[indexPath.item].thumbnailUri
                case "b-roll":
                    thumbnailURI = self.viewmodel.data[indexPath.item].thumbnailUri
                case "instructional":
                    thumbnailURI = self.viewmodel.data[indexPath.item].thumbnailUri
                default:
                    thumbnailURI = self.viewmodel.data[indexPath.item].thumbnailUri
                }
                let urlSession:URLSession = URLSession.shared
                urlSession.dataTask(with: URL(string: thumbnailURI)!) {
                    data, response, error in
                    let image:UIImage? = UIImage(data: data!)
                    DispatchQueue.main.async {
                        videoCell._videoImage.image = image
                        videoCell._videoTitle.text = self.viewmodel.data[indexPath.item].category[0]
                    }
                }.resume()
            } else {
                videoCell._videoImage.image = UIImage(named: "dummyimage1")
            }*/
            
        }
        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /* grab the current cell and the Storyboard instance since we will be using this Storyboard instance to create a SearchViewController from our Main Storyboard */
        let currentCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionView_cell_name, for: indexPath)
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
            resultsController.viewmodel = ViewModel()
            resultsController.viewmodel?.copyData(self.viewmodel)

            self.present(searchController, animated: true, completion: {
                [weak self] in
                //guard let strongSelf = self else { return }
                //resultsController.viewmodel?.copyData(strongSelf.viewmodel)
                //resultsController.viewmodel?.copyData(self?.viewmodel)
            })
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
