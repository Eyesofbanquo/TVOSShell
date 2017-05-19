//
//  Winona.swift
//  TVOSShell
//
//  Created by Markim on 5/18/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation
import UIKit

/* The class for networking */
public class Winona {

    
    public static func fetch(urlString:String, parameters:[String:String], completionHandler:(() -> Void)) throws {
        guard let url = URL(string: urlString) else { return }
        let urlRequest:URLRequest = URLRequest(url: url)
        
    }
}
