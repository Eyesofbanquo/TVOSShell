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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchController.searchResultsUpdater = self
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.itemSize = CGSize(width: 375.0, height: 250.0)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 50)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 50)
        
        
        let frame:CGRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
        self._collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self._collectionView.dataSource = self
        self._collectionView.delegate = self
        
        let cell:UINib = UINib(nibName: "SearchCell", bundle: nil)
        self._collectionView.register(cell, forCellWithReuseIdentifier: searchCellId)
        self._collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(self._collectionView)
        
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
        cell.backgroundColor = UIColor.green
        
        return cell
        
    }
}


extension SearchViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension SearchViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Updating")
    }
}

extension SearchViewController:UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
    }
    
}



