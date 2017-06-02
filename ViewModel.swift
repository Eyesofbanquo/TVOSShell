//
//  ScrollViewModel.swift
//  TVOSShell
//
//  Created by Markim on 5/30/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import Foundation

class ViewModel:VM {
    
    var data:[Video]
    var categories:[DataStore.Category]
    
    init() {
        self.data = []
        self.categories = []
    }
    
    required init(categories:[DataStore.Category]){
        self.data = []
        self.categories = categories
    }

    
    func addDataItem(item: Video) {
        self.data.append(item)
    }
    
    func copyData(_ vm:VM?) {
        //make sure the view model actually exists
        guard let vm = vm else { return }
        self.data = vm.data
    }
    
    func release(){
        self.data = []
    }
}
