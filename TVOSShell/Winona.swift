//
//  Winona.swift
//  TVOSShell
//
//  Created by Markim on 5/18/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

/* The class for networking */
class Winona {
    
    private static var urlRequest:URLRequest?

    
    enum Endpoint {
        case search
    }
    
    static func search(facets:[String:[String]], completionHandler:((DataResponse<Any>) -> Void)?){
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
        
        items.append(URLQueryItem(name: "facets", value: "\(facetSearchString)"))
        items.append(URLQueryItem(name: "types", value: "[\"video\", \"photo\"]"))
        urlComponents.queryItems = items
        
        
        
        //create the url
        guard let url = urlComponents.url else { return }
        
        //instantiate the URLRequest
        self.urlRequest = URLRequest(url: url)
        guard let request = self.urlRequest else { return }
        
        Alamofire.request(request).responseJSON{
            response in
            
            guard let completion = completionHandler else { return }
            completion(response)
        }
        
        
        
    }
    
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
            print(response)
            guard let completion = completionHandler else { return }
            completion()
        })

        
        
    }
}
