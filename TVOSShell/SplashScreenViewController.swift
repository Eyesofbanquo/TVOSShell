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
      var facets:[String:[String]] = ["B-Roll":["featured"],"Featured": ["main", "instruction video"]]
      
      //Gain access to the datastore using this class. This class is the equivalent of a viewmodel
      let ij:InnerJoint = InnerJoint()
      
      Winona.searches(facets: facets, completionHandler: {
        category, sub, response in
        //Winona.dispatchGroup.enter()

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
          
          //print(object)
          //let swaVideo:SWAVideo = SWAVideo(id: id, category: sub, title: title, thumbnailUri: thumbnailUri, date: date, duration: duration, caption: "")
          //ij.add(to: category, video: swaVideo)
          

          let swaVideo2 = Winona.loadVideoInformation(from: id, for: category, in: sub, completionHandler: {
            video in
            ij.add(to: category, video: video)
          })
          //print(swaVideo2)
          //DataStore.add(to: category, video: swaVideo)
          //Winona.dispatchGroup.leave()

        }
        Winona.dispatchGroup.leave()
      })?.notify(queue: .main, execute: {
        UIView.animate(withDuration: 0.4, animations: {
          
        }, completion: {
          completed in
          //Once the animation is completed inject the available categories into the next controller then launch
          if completed {
            let storyboard:UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
            //guard let destination:ScrollMainViewController = storyboard.instantiateViewController(withIdentifier: ScrollMainViewController.storyboard_id) as? ScrollMainViewController else { return }
            guard let destination = storyboard.instantiateViewController(withIdentifier: "new_design_main") as? NDMainViewController else { return }
            destination.ij = InnerJoint()
            destination.ij.categories = [.featured, .b_roll]
            self.navigationController?.pushViewController(destination, animated: true)
            
          }
        })
      })

      /*?.notify(queue: .main, execute: {
        //Execute once all of the API loading has been completed
        UIView.animate(withDuration: 0.4, animations: {
          
        }, completion: {
          completed in
          //Once the animation is completed inject the available categories into the next controller then launch
          if completed {
            let storyboard:UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
            //guard let destination:ScrollMainViewController = storyboard.instantiateViewController(withIdentifier: ScrollMainViewController.storyboard_id) as? ScrollMainViewController else { return }
            guard let destination = storyboard.instantiateViewController(withIdentifier: "new_design_main") as? NDMainViewController else { return }
            destination.ij = InnerJoint()
            destination.ij.categories = [.featured, .b_roll]
            self.navigationController?.pushViewController(destination, animated: true)
            
          }
        })
      })*/
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
