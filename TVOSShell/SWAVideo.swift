//
//  SWAVideo.swift
//  TVOSShell
//
//  Created by Markim on 5/30/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation
import UIKit

struct SWAVideo:Video {
    private(set) var id:String
    private(set) var title:String
    private(set) var thumbnailUri:String
    private(set) var date:String
    private(set) var duration:Double
    private(set) var category: [String]
    
    var thumbnailImage:UIImage? {
        let session = URLSession.shared
        var image:UIImage? = UIImage()
        guard let url = URL(string: thumbnailUri) else { return nil }
        //session.dataTask(with: url)
        session.dataTask(with: url, completionHandler: {
            data, response, error in
            guard let d = data else { return }
            let i = UIImage(data: d)
            image = i
        })
        return image
    }
    
    /*var videoURL:URL?{
        
    }*/
}

extension SWAVideo:Hashable {
    var hashValue:Int {
        get {
            return self.id.hashValue
        }
    }
}

extension SWAVideo:Equatable {
    static func ==(lhs: SWAVideo, rhs: SWAVideo) -> Bool {
        return lhs.hashValue == rhs.hashValue && rhs.hashValue == lhs.hashValue
    }
}
