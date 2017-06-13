////
//  VideoDetailViewController.swift
//  TVOSShell
//
//  Created by Markim on 5/14/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

/* This view controller will be the default detail view controller for all videos for this app. So this will be the inbetween from selecting a video to actually displaying it since this view controller should have all video information for display for the user */
class VideoDetailViewController: UIViewController {
  
  @IBOutlet weak var backgroundImage:UIImageView!
  @IBOutlet weak var videoTitle:UILabel!
  @IBOutlet weak var videoDescription:UILabel!
  @IBOutlet weak var videoDate:UILabel!
  @IBOutlet weak var videoCategories:UILabel!
  @IBOutlet weak var playButton:UIButton!
  @IBOutlet weak var categoriesButton:UIButton!
  
  var controller:AVPlayerViewController!
  
  static var  storyboard_id:String = {
    return "video_detail_controller"
  }()
  
  var backgroundImageCache:NSCache<NSString, UIImage>!
  var videoURLString:String!  //Injectable
  var videoIsPlaying:Bool!
  
  var video:Video! //Injectable
  
  //For the video player
  var bottomNavigationView:VideoBottomBarNavigation!
  var width:CGFloat!
  var height:CGFloat = 400.0
  var animator:UIViewPropertyAnimator!
  var bottomNavigationViewIsVisible:Bool!
  var visibleFrame:CGRect!
  var swipeUpGesture:UISwipeGestureRecognizer!
  var swipeDownGesture:UISwipeGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.categoriesButton.addTarget(self, action: #selector(returnToCategories(_:)), for: .primaryActionTriggered)
    self.playButton.addTarget(self, action: #selector(playVideo(_:)), for: .primaryActionTriggered)
    
    self.backgroundImage.layer.opacity = 0.0
    self.backgroundImageCache = NSCache()
    self.videoIsPlaying = false
    
    self.videoTitle.text = "title: " + self.video.title
    self.videoDate.text = "date (non formatted): " + self.video.date
    self.videoCategories.text = "the category: " + self.video.category.rawValue
    self.videoDescription.text = "caption: " + String(self.video.duration)
    
    
    self.loadThumbnailBackground(self.videoURLString)
    
    /* Set a gradient on the image in the background */
    let gradientLayer:CAGradientLayer = CAGradientLayer()
    gradientLayer.frame = self.backgroundImage.bounds
    gradientLayer.colors = [
      UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).cgColor,
      UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor]
    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
    self.backgroundImage.layer.mask = gradientLayer
    
    //For the video player
    self.bottomNavigationViewIsVisible = false
    self.animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut, animations: nil)
    
    /* Bring up the video bottom bar navigation */
    swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.displayBottomView(_:)))
    swipeUpGesture.direction = .up
    swipeUpGesture.isEnabled = false
    swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.displayBottomView(_:)))
    swipeDownGesture.direction = .down
    swipeDownGesture.isEnabled = false
    self.view.addGestureRecognizer(swipeUpGesture)
    self.view.addGestureRecognizer(swipeDownGesture)
  }
  
  func loadThumbnailBackground(_ urlString:String){
    print(urlString)
    /* Grab the thumbnail of the video on a background thread */
    DispatchQueue.global().async {
      let image:UIImage?
      if self.backgroundImageCache.object(forKey: "image") == nil {
        guard let url = URL(string: urlString) else { return }
        let asset:AVURLAsset = AVURLAsset(url: url, options: nil)
        let imageGenerator:AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        print(asset)
        
        let time:CMTime = CMTime(seconds: 0, preferredTimescale: 1)
        do {
          let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
          image = UIImage(cgImage: cgImage)
          self.backgroundImageCache.setObject(image!, forKey: "image")
          DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.backgroundImage.image = image
            UIView.animate(withDuration: 0.4, animations: {
              self.backgroundImage.layer.opacity = 1.0
            }, completion: {
              completed in
              if completed {
                self.backgroundImage.layer.opacity = 1.0
              }
            })
          })
          
        } catch {
          self.backgroundImage.image = UIImage(named: "dummyimage1")
          //fatalError()
        }
        
      } else {
        self.backgroundImage.image = self.backgroundImageCache.object(forKey: "image")
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //For the video player
    self.width = self.view.bounds.width
    
    /* This frame contains the position in which the bottom navigation bar should be visible */
    visibleFrame = CGRect(x: 0.0, y: self.view.frame.height - self.height, width: self.width, height: self.height)
    self.bottomNavigationView = VideoBottomBarNavigation(frame: CGRect(x: 0.0, y: self.view.bounds.height, width: self.width, height: self.height))
    
    self.bottomNavigationView.width = self.width
    self.bottomNavigationView.height = self.height
    self.bottomNavigationView.isUserInteractionEnabled = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    self.backgroundImageCache.removeAllObjects()
  }
  
  static func playVideo(withURL urlString:String){
    
  }
  
  
  func returnToCategories(_ sender:UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func playVideo(_ sender:UIButton){
    guard let url = URL(string: self.videoURLString) else { return }
    let asset:AVURLAsset = AVURLAsset(url: url)
    let playerItem:AVPlayerItem = AVPlayerItem(url: url)
    //let playerItem:AVPlayerItem = AVPlayerItem(asset: asset)
    let player:AVPlayer = AVPlayer(playerItem: playerItem)
    
    // Create a new AVPlayerViewController and pass it a reference to the player.
    self.controller = AVPlayerViewController()
    self.controller.player = player
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: controller.player?.currentItem)
    
    // Add the video player as a child to this view controller
    self.addChildViewController(controller)
    
    // Add its view so that it will be able to be displayed and also create its frame so that it will have a size
    self.view.addSubview(controller.view)
    controller.view.frame = self.view.bounds
    
    //Notify the child that it has been made a child to this parent view controller
    controller.didMove(toParentViewController: self)
    controller.showsPlaybackControls = true
    controller.player?.play()
    controller.view.isUserInteractionEnabled = true
    
    //Indicate that the video player is running
    self.view.addSubview(self.bottomNavigationView)
    self.swipeUpGesture.isEnabled = true
    self.videoIsPlaying = true
    
    //Force a focus update
    self.setNeedsFocusUpdate()
    self.updateFocusIfNeeded()
  }
  
  func displayBottomView(_ sender: UISwipeGestureRecognizer) {
    
    if sender.direction == .down {
      //If the bottom navigation view is visible then when you swipe down dismiss the view and reenable interaction with the video player
      if self.bottomNavigationView.frame == visibleFrame {
        self.animator.addAnimations {
          self.bottomNavigationView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.width, height: self.height)
        }
        self.animator.addCompletion({
          position in
          /* reenable user interaction on the controller's view */
          self.controller.view.isUserInteractionEnabled = true
          self.swipeDownGesture.isEnabled = false
          self.setNeedsFocusUpdate()
          self.updateFocusIfNeeded()
        })
        
        self.bottomNavigationViewIsVisible = false
        self.animator.startAnimation()
      }
    }
    
    if sender.direction == .up {
      /* this is to display the bottom navigation view and animate it into the screen */
      if bottomNavigationView.frame != visibleFrame{
        self.animator.addAnimations {
          self.bottomNavigationView.frame = CGRect(x: 0.0, y: self.view.frame.height - self.bottomNavigationView.frame.height, width: self.bottomNavigationView.frame.width, height: self.bottomNavigationView.frame.height)
        }
        self.animator.addCompletion({
          position in
          /* disable the user interaction on the video player view */
          self.controller.view.isUserInteractionEnabled = false
          /* enable the swipe down gesture */
          self.swipeDownGesture.isEnabled = true
          /* force a focus update so that the collection view will be focused */
          self.setNeedsFocusUpdate()
          self.updateFocusIfNeeded()
        })
        self.bottomNavigationViewIsVisible = true
        self.animator.startAnimation()
      }
    }
  }
  func up(_ sender:UISwipeGestureRecognizer){
  }
  
  func playerDidFinishPlaying(){
    self.videoIsPlaying = false
    swipeUpGesture.isEnabled = false
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    if self.bottomNavigationView.frame == self.visibleFrame {
      if self.videoIsPlaying {
        return [self.bottomNavigationView.collectionView]
      }
    }
    if let controller = self.controller {
      if self.bottomNavigationView.frame != self.visibleFrame && (controller.player?.rate != 0 && controller.player?.error == nil) {
        return [self.controller.view]
      }
    }
    
    return [backgroundImage]
  }
}
