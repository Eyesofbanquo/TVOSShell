//
//  NDVideoPlayerViewController.swift
//  TVOSShell
//
//  Created by Markim on 6/12/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDVideoPlayerViewController: UIViewController {
  
  @IBOutlet weak var play: NDVideoPlayerControl!
  @IBOutlet weak var restart: NDVideoPlayerControl!
  @IBOutlet weak var favorite: NDVideoPlayerControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return []
  }*/
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
