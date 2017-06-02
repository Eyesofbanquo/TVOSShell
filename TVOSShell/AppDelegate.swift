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

        /* This will be loading up on the splash screen */
        //Authenticate
        Winona.auth {
            //Perform network searches
            var featuredFacets:[String:[String]] = ["B-Roll":["featured"],"Featured": ["main"]]
            var facets:[String:[String]] = ["Featured": ["main"]]
            /*Winona.searches(facets: featuredFacets, completionHandler: {
                category, sub, response in
                
                guard let data = response.data else { return }
                
                //create the json object using SwiftyJSON
                let json = JSON(data: data)
                
                //create the category these videos fall under - make this a function in datastore
                //let category:DataStore.Category = .featured
                
                var videos:[Video] = []
                
                for doc in json["docs"] {
                    let object = doc.1
                    let duration:Double = object["duration"].doubleValue
                    let title:String = object["title"].stringValue
                    let id:String = object["key"]["id"].stringValue
                    let thumbnailUri:String = object["thumbnailUri"].stringValue
                    let date:String = object["date"].stringValue
                    
                    let swaVideo:SWAVideo = SWAVideo(id: id, category: sub, title: title, thumbnailUri: thumbnailUri, date: date, duration: duration)
                    videos.append(swaVideo)
                    //print(videos)
                    DataStore.add(to: category, video: swaVideo)
                }
            })*/
            
            Winona.searches(facets: featuredFacets, completionHandler: {
                category, sub, response in
                guard let data = response.data else { return }

                //create the json object using SwiftyJSON
                let json = JSON(data: data)
                
                //create the category these videos fall under - make this a function in datastore
                //let category:DataStore.Category = .featured
                
                var videos:[Video] = []
                
                for doc in json["docs"] {
                    let object = doc.1
                    let duration:Double = object["duration"].doubleValue
                    let title:String = object["title"].stringValue
                    let id:String = object["key"]["id"].stringValue
                    let thumbnailUri:String = object["thumbnailUri"].stringValue
                    let date:String = object["date"].stringValue
                    
                    let swaVideo:SWAVideo = SWAVideo(id: id, category: sub, title: title, thumbnailUri: thumbnailUri, date: date, duration: duration)
                    DataStore.add(to: category, video: swaVideo)

                }
                print(DataStore.videos[category])
                
                
                
            })
            /*Winona.search(facets: ["Featured":["main"]], completionHandler: {
                response in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    //print(response)

                    DataStore.loadFromAPI(data: data, to: .featured, with: .main)
                    
                    //create the json object using SwiftyJSON
                    let json = JSON(data: data)
                    
                    //create the category these videos fall under - make this a function in datastore
                    let category:DataStore.Category = .featured
                    
                    var videos:[Video] = []
                    
                    for doc in json["docs"] {
                        let object = doc.1
                        let duration:Double = object["duration"].doubleValue
                        let title:String = object["title"].stringValue
                        let id:String = object["key"]["id"].stringValue
                        let thumbnailUri:String = object["thumbnailUri"].stringValue
                        let date:String = object["date"].stringValue
                        let c:DataStore.Category.Sub = .main
                        
                        let swaVideo:SWAVideo = SWAVideo(id: id, category: c, title: title, thumbnailUri: thumbnailUri, date: date, duration: duration)
                        videos.append(swaVideo)
                        DataStore.add(to: category, video: swaVideo)
                    }
                    print(DataStore.videos[category])
                    
                case .failure(let error):
                    print(error)
                }
            })*/
        }
        //DispatchGroup.notify(DataStore.dispatchGroup)
       
        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

