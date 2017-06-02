//
//  FeaturedTableViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class FeaturedTableViewController: UIViewController {
    
    fileprivate let featured_cell:String = "featured_cell"
    static let storyboardid:String = "featuredviewcontroller"
    fileprivate let featured_cell_segue:String = "featured_cell_segue"

    @IBOutlet weak var _tableView:UITableView!
    
    let model:[[UIColor]] = [[UIColor.red, UIColor.black, UIColor.blue,UIColor.red, UIColor.black, UIColor.blue,UIColor.red, UIColor.black, UIColor.blue],[UIColor.red, UIColor.black, UIColor.blue],[UIColor.red, UIColor.black, UIColor.blue]]
    
    //Inject the values for these two variables
    var videos:[[Video]]!
    var subcategories:[SubCategory]!
    
    let categorySectionHeaders:[String] = ["Featured", "Your Videos 1", "Your Videos 2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Assign this viewcontrolelr as the delegate and datasource for its UITableView
        self._tableView.delegate = self
        self._tableView.dataSource = self
        self._tableView.remembersLastFocusedIndexPath = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Disable tableview focusing in favor for focusing on collectionview items inside each tableview row */
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
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
        return self.categorySectionHeaders[section]
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
        return model.count
    }
}

/* Extensions for UICollectionView */
extension FeaturedTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].count
    }


}

extension FeaturedTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featured_cell, for: indexPath) as? FeaturedCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        return cell
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
