//
//  VideoDetailViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/14/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

/* This view controller will be the default detail view controller for all videos for this app. So this will be the inbetween from selecting a video to actually displaying it since this view controller should have all video information for display for the user */
class VideoDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImage:UIImageView!
    @IBOutlet weak var videoTitle:UILabel!
    @IBOutlet weak var videoDescription:UILabel!
    @IBOutlet weak var videoDate:UILabel!
    @IBOutlet weak var videoCategories:UILabel!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var categoriesButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoriesButton.addTarget(self, action: #selector(returnToCategories(_:)), for: .primaryActionTriggered)
        self.playButton.addTarget(self, action: #selector(playVideo(_:)), for: .primaryActionTriggered)
        
        /* Set a thumbnail real quick */
        DispatchQueue.main.async {
            guard let url = URL(string: "https://wieck-swa-production.s3.amazonaws.com/videos/056c0b9e14e5c48338468f8ede20c4b7387ae14f/source.mov") else { return }
            let asset:AVURLAsset = AVURLAsset(url: url, options: nil)
            let imageGenerator:AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            let time:CMTime = CMTime(seconds: 0, preferredTimescale: 1)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                self.backgroundImage.image = image
            } catch {
                fatalError()
            }
        }
        
        
        /* Set a gradient on the image in the background */
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundImage.bounds
        gradientLayer.colors = [
            UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundImage.layer.mask = gradientLayer
        
    }
    
    func returnToCategories(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func playVideo(_ sender:UIButton){
        guard let url = URL(string: "https://wieck-swa-production.s3.amazonaws.com/videos/056c0b9e14e5c48338468f8ede20c4b7387ae14f/source.mov") else { return }
        let playerItem:AVPlayerItem = AVPlayerItem(url: url)
        let player:AVPlayer = AVPlayer(playerItem: playerItem)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: controller.player?.currentItem)
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func playerDidFinishPlaying(){
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [backgroundImage]
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
