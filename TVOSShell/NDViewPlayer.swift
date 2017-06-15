//
//  NDViewPlayer.swift
//  TVOSShell
//
//  Created by Markim on 6/15/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVKit

class NDViewPlayer: UIViewController {
  
  var player: AVPlayerViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: controller.player?.currentItem)
    
    // Add the video player as a child to this view controller
    self.addChildViewController(player)
    
    // Add its view so that it will be able to be displayed and also create its frame so that it will have a size
    self.view.addSubview(player.view)
    player.view.frame = self.view.bounds
    
    //Notify the child that it has been made a child to this parent view controller
    player.didMove(toParentViewController: self)
    player.showsPlaybackControls = true
    player.player?.play()
    player.view.isUserInteractionEnabled = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(NDViewPlayer.endVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.player?.currentItem)
  }
  
  func endVideo() {
    NotificationCenter.default.removeObserver(self)
    self.dismiss(animated: true, completion: nil)
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
