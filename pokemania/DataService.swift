//
//  DataService.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import Foundation
class DataService {
    static let instance = DataService()
    
    var data:[Pokemon] = [Pokemon]()
    var filteredArray = [Pokemon]()
    
    
    
    
    
    func insert(pokemon:Pokemon) -> Void{
        self.data.append(pokemon)
    }
    
    func delete(position:Int){
        self.data.remove(at: position)
    }
    
    
    
    
}
