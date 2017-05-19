//
//  SearchViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/17/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchController:UISearchController!
    var _collectionView:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.itemSize = CGSize(width: 375.0, height: 250.0)
        let frame:CGRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
        self._collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self._collectionView.dataSource = self
        self._collectionView.delegate = self
        
        let cell:UINib = UINib(nibName: "SearchCell", bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return UICollectionViewCell()
    }
}

extension SearchViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
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



