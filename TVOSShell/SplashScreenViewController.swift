//
//  SplashScreenViewController.swift
//  TVOSShell
//
//  Created by Markim on 6/1/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var logo:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Authenticate
        Winona.auth {
            //Perform network searches
            var facets:[String:[String]] = ["B-Roll":["featured"],"Featured": ["main", "instruction video"]]
            
            //Gain access to the datastore
            var ij:InnerJoint = InnerJoint()
            
            Winona.searches(facets: facets, completionHandler: {
                category, sub, response in
                
                guard let data = response.data else { return }
                
                //create the json object using SwiftyJSON
                let json = JSON(data: data)
                
                for doc in json["docs"] {
                    let object = doc.1
                    let duration:Double = object["duration"].doubleValue
                    let title:String = object["title"].stringValue
                    let id:String = object["key"]["id"].stringValue
                    let thumbnailUri:String = object["thumbnailUri"].stringValue
                    let date:String = object["date"].stringValue
                    
                    let swaVideo:SWAVideo = SWAVideo(id: id, category: sub, title: title, thumbnailUri: thumbnailUri, date: date, duration: duration)
                    ij.add(to: category, video: swaVideo)
                    //DataStore.add(to: category, video: swaVideo)
                    
                }
            })
            //Execute once all of the API loading has been completed
            Winona.dispatchGroup.notify(queue: .main, execute: {

                //print(DataStore.modelData(for: .featured))
                UIView.animate(withDuration: 0.4, animations: {
                    
                }, completion: {
                    completed in
                    //Once the animation is completed inject the available categories into the next controller then launch
                    if completed {
                        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let destination:ScrollMainViewController = storyboard.instantiateViewController(withIdentifier: ScrollMainViewController.storyboard_id) as? ScrollMainViewController else { return }
                        //destination.categories = [.featured, .b_roll]
                        destination.ij = InnerJoint()
                        destination.ij.categories = [.featured, .b_roll]
                        self.navigationController?.pushViewController(destination, animated: true)
                        
                    }
                })
            })
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
