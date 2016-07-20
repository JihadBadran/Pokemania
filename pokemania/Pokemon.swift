//
//  Pokemon.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import Foundation
class Pokemon{
    private var _name:String!
    private var _pokID:Int!
    
    var name:String{
        get{
            return _name
        }
    }
    var poID:Int{
        get{
            return _pokID
        }
    }
    
    init(name:String,ID:Int) {
        self._name = name
        self._pokID = ID
    }
    
}
