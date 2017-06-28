//
//  Winona.swift
//  TVOSShell
//
//  Created by Markim on 5/18/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation
import CloudKit
import Alamofire
import SwiftyJSON
import UIKit

/* The class for networking */
class Winona {
  
  private static var urlRequest: URLRequest?
  static private(set) var dispatchGroup: DispatchGroup = DispatchGroup()
  static private(set) var authenticated: Bool = false
  
  static private(set) var favoriteVideos: [String] = []
  
  static private(set) var facets: [String] = []
  static private(set) var categories: [String] = []
  

  /// Add video to the users favorites
  ///
  /// - Parameter id: video id to favorite
  static func add(toFavorites id: String) -> Bool{
    if !favoriteVideos.contains(id) {
      favoriteVideos.append(id)
      return true
    }
    return false
  }
  static func remove(fromFavorites id: String) {
    guard favoriteVideos.count != 0 else { return }
    for (index, i) in favoriteVideos.enumerated() {
      if i == id {
        favoriteVideos.remove(at: index)
        return
      }
    }
  }
  
  //Use cloudkit here
  static func loadFavorites() {
    
  }
  
  /// This will connect to cloudkit's dashboard and pull the collection of categories for the search
  static func cloudkitConnect(from view: UIViewController, completionHandler: (([String: [String]]) -> Void)?) {
    let container = CKContainer.default()
    let _database = container.publicCloudDatabase
    
    CKContainer.default().accountStatus(completionHandler: {
      status, error in
      
      if case CKAccountStatus.available = status {
        let predicate = NSPredicate(value: true) // predicate to return all values
        let query = CKQuery(recordType: "Facets", predicate: predicate)
        
        
        
        _database.perform(query, inZoneWith: nil, completionHandler: {
          records, error in
          
          if error != nil {
            print(error!)
            return
          }
          
          guard let cloudRecords = records else { return }
          var facets: [String: [String]] = [:]
          
          //only one record should matter since you're using the private database here
          let personalRecord = cloudRecords[0]
          
          guard let categories = personalRecord.object(forKey: "categories") as? [String] else { return }
          guard let subCategories = personalRecord.object(forKey: "sub_categories") as? [String] else { return }
          
          //self.categories = categories
          
          let combinedCategories = subCategories.map {
            sub in
            return sub.components(separatedBy: ",")
          }
          
          for (index, value) in categories.enumerated() {
            //print(value)
            self.categories.append(value)
            facets[value] = combinedCategories[index]
            //self.categories.append(value)
          }
          
          guard let completion = completionHandler else { return }
          completion(facets)
          //completionHandler(facets)
          
          
        })
      } else {
        let alert = UIAlertController(title: "iCloud", message: "This app makes use of iCloud. Please make sure you are logged into your iCloud account", preferredStyle: .alert)
        //load a different view in the handler that takes them to a view forcing them to go back and log into their account
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      }
      
    })
  }
  
  static func searches(facets:[String:[String]], completionHandler:((String, String, (DataResponse<Any>)) -> Void)?) -> DispatchGroup? {
    //Get the index for the first category
    var categoryIndex = facets.startIndex
    
    //While there are more indices in the dictionary continue to search. else stop searching. This cycles through both the key and the array value in the format [Featured:[Main,Instruction,...]]
    while categoryIndex != facets.endIndex {
      for subCategory in facets[categoryIndex].value {
        //guard let category = DataStore.Category(string: facets[categoryIndex].key) else { return nil }
        //guard let sub = DataStore.Category.Sub(rawValue: subCategory) else { return nil }
        
        let category = facets[categoryIndex].key
        let sub = subCategory
        
        self.search(facets: [category: [sub]], completionHandler: {
          response in
          guard let completion = completionHandler else { return }
          completion(category, sub, response)
        })
      }
      
      categoryIndex = facets.index(after: categoryIndex)
    }
    return self.dispatchGroup
  }
  
  private static func search(facets:[String: [String]], completionHandler:((DataResponse<Any>) -> Void)?){
    //Build the url string
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/search"
    
    //create query items
    var items:[URLQueryItem] = []
    var facetSearchString:String = ""
    
    //Get the starting index of the facets argument
    var index = facets.startIndex
    
    //Go through each index of the facets and create a string that will be used to search the API. If the index isn't the last then make sure to append a comma to indicate the start of the following key
    while index != facets.endIndex {
      facetSearchString += "\"\(facets[index].key)\": \(facets[index].value)"
      if facets.index(after: index) != facets.endIndex {
        index = facets.index(after: index)
        facetSearchString += ","
        continue
      } else {
        break
      }
    }
    
    //Finalize the facet string and add to the query items
    facetSearchString = "{\(facetSearchString)}"
    
    //Add the query items to the url to build the api endpoint
    items.append(URLQueryItem(name: "facets", value: "\(facetSearchString)"))
    //items.append(URLQueryItem(name: "facets", value: "{Featured: main}"))
    items.append(URLQueryItem(name: "types", value: "[\"video\", \"photo\"]"))
    urlComponents.queryItems = items
    
    //create the url
    guard let url = urlComponents.url else { return }
    
    //instantiate the URLRequest
    self.urlRequest = URLRequest(url: url)
    guard let request = self.urlRequest else { return }
    
    //Enter the dispatch group to indicate the start of each task that must be completed on notify
    self.dispatchGroup.enter()
    
    Alamofire.request(request).responseJSON{
      response in
      
      guard let completion = completionHandler else { return }
      //print(response)
      completion(response)
      //self.dispatchGroup.leave()
    }
    
    
  }
  
  /// Request authorization from SWA API
  ///
  /// - Parameter completionHandler: What will be performed upon successful authorization
  static func auth(completionHandler:(() -> Void)?){
    
    //Build the url string
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/authenticate"
    
    guard let url = urlComponents.url else { return }
    self.urlRequest = URLRequest(url: url)
    self.urlRequest?.httpMethod = "POST"
    
    //credentials
    let json:[String:Any] = ["email":"markim@wieck.com","password":"test"]
    let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    self.urlRequest?.httpBody = body
    self.urlRequest?.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    guard let request = urlRequest else { return }
    Alamofire.request(request).responseJSON(completionHandler: {
      response in
      guard let completion = completionHandler else { return }
      self.authenticated = true
      completion()
    })
  }
  
  static func loadVideoInformation(from id: String, for category: String, in sub: String, completionHandler: ((Video) -> Void)?){
    
    var urlComponents:URLComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "stage-swatv.wieck.com"
    urlComponents.path = "/api/v1/videos/\(id)"
    
    self.dispatchGroup.enter()
    Alamofire.request(urlComponents).responseJSON(completionHandler: {
      response in
      switch response.result {
        
      case .success(_):
        let json = JSON(data: response.data!)
        var videoURLString: String
        videoURLString = json["downloads"]["720p"]["uri"].stringValue
        
        // MARK: Get the date the video was actually created - uncomment below
        
        let authorAtString = json["source"]["authoredAt"].stringValue
        
        let index = videoURLString.index(videoURLString.startIndex, offsetBy: 88)
        
        let thumbnailString = videoURLString.substring(to: index) + ".jpg"
        
        let duration = json["source"]["duration"].doubleValue
        
        let title = json["title"].stringValue
        
        let description = json["caption"].stringValue
        
        if json["downloads"]["source"] != JSON.null {
          videoURLString = json["downloads"]["source"]["uri"].stringValue
        } else if json["downloads"]["720p"] != JSON.null {
          videoURLString = json["downloads"]["720p"]["uri"].stringValue
        }
        
        let v = SWAVideo(id: id, category: sub, title: title, thumbnailUri: thumbnailString, date: authorAtString, duration: duration, caption: description, videoURL: videoURLString)
        completionHandler!(v)
        
        self.dispatchGroup.leave()
      case .failure(_):
        break
      }
    })
  }
}
