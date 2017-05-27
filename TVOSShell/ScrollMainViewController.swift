//
//  ScrollMainViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/15/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import Foundation

class ScrollMainViewController: UIViewController {
    
    @IBOutlet weak var _topFeaturedView:TopFeaturedView!
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _backgroundImage:UIImageView!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    let numberOfScrollViewPages:CGFloat! = 3.0
    let collectionView_cell_name:String = "video_cell"
    
    var imageCache:NSCache<NSString, UIImage>!

    
    /* For testing purposes only */
    let modelCount:Int = 5
    
    
    var featuredVideos:[UIImage?]!
    
    var urlSession:URLSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._collectionView.delegate = self
        self._collectionView.dataSource = self
        self._collectionView.remembersLastFocusedIndexPath = true

        
        let blurEffect:UIBlurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self._backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._backgroundImage.addSubview(blurEffectView)
        
        //Testing purposes
        let url = URL(string: "https://stage-swatv.wieck.com/api/v1/authenticate")
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let json:[String:Any] = ["email":"markim@wieck.com","password":"test"]
        //let body = try? JSONSerialization.jsonObject(with: ["email":"markim@wieck.com", "password":"test"], options: .allowFragments)
        let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        urlRequest.httpBody = body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        self.urlSession = URLSession.shared
        
        var task2:URLSessionDataTask = URLSessionDataTask()
        
        let task = self.urlSession.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String: String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey:Any]()
                    cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
                    cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
                    cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain
                    cookieProperties[HTTPCookiePropertyKey.path] = cookie.path
                    cookieProperties[HTTPCookiePropertyKey.version] = cookie.version
                    cookieProperties[HTTPCookiePropertyKey.expires] = Date().addingTimeInterval(313546000)
                    let newCookie = HTTPCookie(properties: cookieProperties)
                    //HTTPCookieStorage.shared.setCookie(newCookie!)
                    print("name: \(cookie.name)")
                    //task2.resume()
                }
            }
            print(statusCode)
        })
        //task.resume()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "stage-swatv.wieck.com"
        urlComponents.path = "/api/v1/search"
        let queryItems:[URLQueryItem] = [URLQueryItem(name: "facets", value: "{}"), URLQueryItem(name: "query", value: "simpsons"), URLQueryItem(name: "types", value:"[\"video\", \"photo\"]")]
        urlComponents.queryItems = queryItems
        print(urlComponents.url)

        urlRequest = URLRequest(url: urlComponents.url!)
        
        task2 = self.urlSession.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            print(response)
        })
       // task2.resume()
        //Set up the image cache to store the images loaded from the API
        self.imageCache = NSCache()
        
        /*load videos from the API*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //When hitting a memory warning just remove all cached objects
        self.imageCache.removeAllObjects()
    }
    
    /* The title/featured image should change its image based on which item is currently focused in the collection view. This will be done by casting the nextFocusedView as a VideoCell and ravaging its positionInCollectionView property to determine which Cell was actually focused. Then you display its featured image */
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        
        guard let video_cell = context.nextFocusedView as? VideoCell else { return }
        self._topFeaturedView.featuredImageView.image = video_cell._videoImage.image

        guard let previous_video_cell = context.previouslyFocusedView as? VideoCell else { return }
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.22, animations: {
            self._topFeaturedView.layer.opacity = 0.0
        })
       /* coordinator.addCoordinatedAnimations({
            UIView.setAnimationCurve(.easeIn)
            UIView.animate(withDuration: UIView.inheritedAnimationDuration * 20, animations: {
                self._topFeaturedView.layer.opacity = 0.0
            })
        }, completion: nil)*/
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.22, animations: {
            self._topFeaturedView.layer.opacity = 1.0
            
        })
        /*coordinator.addCoordinatedAnimations({
            UIView.setAnimationCurve(.easeIn)
            UIView.animate(withDuration: UIView.inheritedAnimationDuration * 20, animations: {
                self._topFeaturedView.layer.opacity = 1.0

            })
        }, completion: nil)*/
        
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
        
        func newFucntion() {
            
        }
        
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
            videoCell._videoImage.image = UIImage(named: "dummyimage1")
        }
        //videoCell.positionInCollectionView = indexPath.item
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
