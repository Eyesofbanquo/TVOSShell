//
//  SearchViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/17/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

extension UISearchBar {
    override open var canBecomeFocused:Bool {
        return true
    }
}

class SearchViewController: UIViewController {
    
    var searchController:UISearchController!
    var _collectionView:UICollectionView!
    
    let searchCellId:String = "search_cell"
    
    var defaultCollectionViewTopConstraint:NSLayoutYAxisAnchor!
    let searchControllerFocusGuide:UIFocusGuide = UIFocusGuide()
    var searchTextField:UITextField!
    var oldBounds:CGRect!

    var viewmodel:VM?
    
    var downloadImageSession:URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create the flow layout for the collection view
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.itemSize = CGSize(width: 375.0, height: 250.0)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 50)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 50)
        
        //Create the collection view
        let frame:CGRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
        self._collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self._collectionView.dataSource = self
        self._collectionView.delegate = self
        
        //Give the collectionview information about the type of cell it should display
        //register the cell to the collection view
        //display the collection
        let cell:UINib = UINib(nibName: "SearchCell", bundle: nil)
        self._collectionView.register(cell, forCellWithReuseIdentifier: searchCellId)
        self._collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(self._collectionView)
        
        self.downloadImageSession = URLSession.shared
        
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self._collectionView]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addLayoutGuide(searchControllerFocusGuide)
        
        self.oldBounds = self._collectionView.bounds
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchCellId, for: indexPath) as? SearchCellCollectionViewCell else { return UICollectionViewCell() }
        guard   let vm = self.viewmodel,
                let swavideo = vm.data[indexPath.item] as? SWAVideo,
                let url = URL(string: swavideo.thumbnailUri)
            else { return UICollectionViewCell() }
        
        //Download the image
        self.downloadImageSession.dataTask(with: url) {
            data, response, error in
            guard let d = data else { return }
            let image:UIImage? = UIImage(data: d)
            DispatchQueue.main.async {
                cell._cellImage.image = image
                cell._cellImage.layer.opacity = 0.0
                UIView.animate(withDuration: 0.44, animations: {
                    cell._cellImage.layer.opacity = 1.0
                })
            }
        }.resume()
        
        //store the image in cache
        
        //apply image to the uiimageview
        
        
        
        //cell._cellImage.image = swavideo.thumbnailImage
        
        //cell.backgroundColor = UIColor.green
        
        return cell
        
    }
}


extension SearchViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = self.viewmodel else { return 0 }
        return vm.data.count
    }
}

extension SearchViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.characters.count > 1 else { return }
        
    }
}

extension SearchViewController:UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
    }
    
}



