//
//  DataStore.swift
//  TVOSShell
//
//  Created by Markim on 5/31/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation
/// Typealias for Category.Sub
typealias SubCategory = DataStore.Category.Sub

class DataStore {
    
    enum Category:String {
        case featured = "Featured"
        case b_roll = "B-Roll"
        
        init?(string:String){
            switch string{
                case "Featured":
                    self = .featured
                case "B-Roll":
                    self = .b_roll
            default:
                self = .featured
            }
        }
        
        enum Sub:String {
            case main = "main"
            case featured = "featured"
        }
    }
    
    
    
    static private(set) var dispatchGroup:DispatchGroup = DispatchGroup()
    
    static private(set) var videos:[Category:[Video]] = [:]
    
    static private(set) var numberOfCategories:Int = {
        return videos.count
    }()
    
    /*static private(set) var videos:[Category:[Video]] = {

        return self.videoStore
    }()*/
    
    //Set this so that this class cannot be instantiated thus officially making it a singleton
    private init(){
        
    }
    
    static func loadFromAPI(data:Data, to category:Category, with subCategory:Category.Sub){
        
    }
    
    /// Description
    /// - parameter category: The category you will add the videos to
    /// - parameter videos: The array of videos you'll add to the category you provide
    static func add(to category:Category, videos:[Video]) {
        if self.videos[category] == nil {
            self.videos[category] = []
        }
        self.videos[category]? = videos
    }
    
    static func add(to category:Category, video:Video){
        //Create the new category in the data store
        if self.videos[category] == nil {
            self.videos[category] = []
        }
        let filteredVideos = self.videos[category]?.filter({
            v in
            if video.id == v.id {
                return false
            } else {
                return true
            }
        })
        
        //If the filtered video count is the same as the videoStore video count then that means nothing was filtered out. There for you can add the new video to the list.
        //If the filtered count is less than the videoStore count then that means you're trying to add a duplicate so you shoulnd't add anything new to the list
        if filteredVideos?.count == self.videos[category]?.count {
            self.videos[category]?.append(video)
        }
    }
    
}
