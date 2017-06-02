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
typealias InnerJoint = DataStore.InnerJoint

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
            case instruction_video = "instruction video"
        }
    }
    
    /* This class will power the DataStore
        Possibly replace view models */
    class InnerJoint {
        
        var categories:[Category]?
        
        
        func firstItem(in category:DataStore.Category, with sub:SubCategory) -> Video? {
            for videos in self.data(for: category) {
                if videos[0].category == sub {
                    return videos[0]
                }
            }
            return nil
        }
        
        func data(for category:DataStore.Category) -> [[Video]] {
            return DataStore.modelData(for:category)
        }
        
        func add(to category:Category, video:Video) {
            DataStore.add(to: category, video: video)
        }
    }
    
    
    static private var dispatchGroup:DispatchGroup = DispatchGroup()
    
    static private var videos:[Category:[Video]] = [:]
    
    static private(set) var numberOfCategories:Int = {
        return videos.count
    }()
    
    
    //Set this so that this class cannot be instantiated thus officially making it a singleton
    private init(){
        
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
    
    private static func add(to category:Category, video:Video){
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
    
    
    
    static private func modelData(for category:DataStore.Category) -> [[Video]]{
        var finalData:[[Video]] = []
        switch category {
        case .featured:
            var main:[Video] = []
            var instruction:[Video] = []
            _ = self.videos[category]?.map {
                video in
                switch video.category {
                case .instruction_video:
                    instruction.append(video)
                case .main:
                    main.append(video)
                default:break
                }
            }
            finalData.append(main)
            finalData.append(instruction)
        case .b_roll:
            var featured:[Video] = []
            _ = self.videos[category]?.map {
                video in
                switch video.category {
                case .featured:
                    featured.append(video)
                default:break
                }
            }
            finalData.append(featured)
        }
        return finalData
    }
    
}
