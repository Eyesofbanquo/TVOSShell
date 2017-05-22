//
//  ScrollMainViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/15/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class ScrollMainViewController: UIViewController {
    
    @IBOutlet weak var _topFeaturedView:TopFeaturedView!
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _backgroundImage:UIImageView!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    let numberOfScrollViewPages:CGFloat! = 3.0
    let collectionView_cell_name:String = "video_cell"

    
    /* For testing purposes only */
    let modelCount:Int = 5
    
    
    var featuredVideos:[UIImage?]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._collectionView.delegate = self
        self._collectionView.dataSource = self
        
        let blurEffect:UIBlurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self._backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._backgroundImage.addSubview(blurEffectView)
        
        /*load videos from the API*/
        
        /* set the featured images from API*/
        let image1:UIImage? = UIImage(named: "slide1")
        let image2:UIImage? = UIImage(named: "slide2")
        let image3:UIImage? = UIImage(named: "slide3")
        
        self.featuredVideos = [image1, image2, image3]
        
        /* Assign closure to imageview */
        self._topFeaturedView.setup(pos: 0, image: self.featuredVideos[0], action: self.scrollFeaturedImage(next:))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Create a focus layout as an empty view for the top featured image to allow a scrolling effect */
        let focusGuideLeftOfFeaturedView:UIFocusGuide = UIFocusGuide()
        self.view.addLayoutGuide(focusGuideLeftOfFeaturedView)
        focusGuideLeftOfFeaturedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        focusGuideLeftOfFeaturedView.rightAnchor.constraint(equalTo: self._topFeaturedView.leftAnchor).isActive = true
        focusGuideLeftOfFeaturedView.topAnchor.constraint(equalTo: self._topFeaturedView.topAnchor).isActive = true
        focusGuideLeftOfFeaturedView.bottomAnchor.constraint(equalTo: self._topFeaturedView.bottomAnchor).isActive = true
        
        
        let focusGuideRightOfFeaturedView:UIFocusGuide = UIFocusGuide()
        self.view.addLayoutGuide(focusGuideRightOfFeaturedView)
        focusGuideRightOfFeaturedView.leftAnchor.constraint(equalTo: self._topFeaturedView.rightAnchor).isActive = true
        focusGuideRightOfFeaturedView.topAnchor.constraint(equalTo: self._topFeaturedView.topAnchor).isActive = true
        focusGuideRightOfFeaturedView.bottomAnchor.constraint(equalTo: self._topFeaturedView.bottomAnchor).isActive = true
        focusGuideRightOfFeaturedView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    func scrollFeaturedImage(next:Int){
        self._topFeaturedView.imageView.image = nil
        let count = self.featuredVideos.count
        if next % count > 0 {
            self._topFeaturedView.imageView.image = self.featuredVideos[next % count]

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        /* Make the first cell the cell that opens the SearchViewController/begins search feature/makes visible search bar */
        switch indexPath.item {
        case 0:
            videoCell._videoImage.image = UIImage(named: "search_icon")
            videoCell._videoTitle.text = "Search"
        case self.modelCount - 1:
            videoCell._videoImage.image = UIImage(named: "settings")
            videoCell._videoTitle.text = "Settings"
        default:
            videoCell._videoImage.image = UIImage(named: "dummyimage1")
        }

        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionView_cell_name, for: indexPath)
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.item {
        case 0:
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
