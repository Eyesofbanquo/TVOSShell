//
//  UpcomingEventsViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/12/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: UIViewController {
    
    fileprivate let upcoming_event_cell:String = "upcoming_event"
    static let storyboardid:String = "upcomingeventsviewcontroller"
    
    
    @IBOutlet weak var _collectionView:UICollectionView!
    let model:[UIColor] = [UIColor.red, UIColor.black, UIColor.blue]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self._collectionView.dataSource = self
        self._collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
        }
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

extension UpcomingEventsViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.upcoming_event_cell, for: indexPath) as? UpcomingEventsCell else { return UICollectionViewCell() }
        cell.backgroundColor = model[indexPath.row]
        return cell
        //return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension UpcomingEventsViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
}
