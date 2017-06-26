//
//  AppDelegate.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
    }
    catch {
      print("Setting category to AVAudioSessionCategoryPlayback failed.")
    }
    
    ///Load from splash screen first
    /*let storyboard:UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
    guard let splashScreen = storyboard.instantiateViewController(withIdentifier: "splash_screen") as? SplashScreenViewController else { return false}
    let navigationController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "navigation_controller") as! UINavigationController
    navigationController.pushViewController(splashScreen, animated: false)
    navigationController.setNavigationBarHidden(true, animated: false)
    
    window?.rootViewController = navigationController*/
    
    /*let ndStoryboard: UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
    guard let mainView: NDMainViewController = ndStoryboard.instantiateViewController(withIdentifier: "new_design_main") as? NDMainViewController else { return false }
    let navigationController: UINavigationController = UINavigationController(rootViewController: mainView)
    //navigationControlle
    navigationController.setNavigationBarHidden(true, animated: false)
    self.window?.rootViewController = navigationController
    //navigationController.view.frame = CGRect(x: 0,y: 0, width: 1920, height: 1080)
    //
    //window?.makeKeyAndVisible()
    
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.clipsToBounds = true*/
    
    
    /*Winona.auth(completionHandler: {
      let facets: [String: [String]] = ["B-Roll":["featured"],"Featured": ["main", "instruction video"]]
      
      //Gain access to the datastore using this class. This class is the equivalent of a viewmodel
      let ij:InnerJoint = InnerJoint()
      
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
          
        }
      })?.notify(queue: .main, execute: {
        //Execute once all of the API loading has been completed
        UIView.animate(withDuration: 0.4, animations: {
          
        }, completion: {
          completed in
          //Once the animation is completed inject the available categories into the next controller then launch
          if completed {
            let storyboard:UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
            guard let destination = storyboard.instantiateViewController(withIdentifier: "new_design_main") as? NDMainViewController else { return }
            destination.ij = InnerJoint()
            destination.ij.categories = [.featured, .b_roll]
            navigationController.pushViewController(destination, animated: true)
            //return true
            print(destination.ij.allData)
          }
        })
      })
      
      
    })*/
    
    //self.window?.rootViewController = navigationController
    
    /* This will be loading up on the splash screen */
    //Authenticate
    //Winona.auth(completionHandler: nil)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //Reauthenticate the app to make sure everything will continue to work
    if !Winona.authenticated {
      Winona.auth(completionHandler: nil)
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

