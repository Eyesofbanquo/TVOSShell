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
    
    //let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //guard let splashScreen = storyboard.instantiateViewController(withIdentifier: "splash_screen") as? SplashScreenViewController else { return false}
    //let navigationController:UINavigationController = UINavigationController(rootViewController: splashScreen)
    //navigationController.setNavigationBarHidden(true, animated: false)
    
    let ndStoryboard: UIStoryboard = UIStoryboard(name: "New_Design", bundle: nil)
    guard let mainView: NDMainViewController = ndStoryboard.instantiateViewController(withIdentifier: "new_design_main") as? NDMainViewController else { return false }
    let navigationController: UINavigationController = UINavigationController(rootViewController: mainView)
    navigationController.setNavigationBarHidden(true, animated: false)
    self.window?.rootViewController = navigationController
    
    Winona.auth(completionHandler: {
      let facets: [String: [String]] = ["B-Roll":["featured"],"Featured": ["main", "instruction video"]]
      
    })
    
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

