//
//  CustomVideoPlayerController.swift
//  TVOSShell
//
//  Created by Markim on 5/25/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CustomVideoPlayerController: AVPlayerViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(player:AVPlayer){
        super.init(nibName: "Main", bundle: nil)
        self.player = player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.displayBottomNavigation(_:)))
        print("loaded")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.player?.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayBottomNavigation(_ sender: UISwipeGestureRecognizer) {
        
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
