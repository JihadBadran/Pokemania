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
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionText:String!
    private var _pokemonUrl:String!
    
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
    var defense:String{
        get{
            return _defense
        }
    }
    var type:String{
        get{
            return _type
        }
    }
    var height:String{
        get{
            return _height
        }
    }
    var weight:String{
        get{
            return _weight
        }
    }
    var attack:String{
        get{
            return _attack
        }
    }
    var nextEvolutionText:String{
        get{
            return _nextEvolutionText
        }
    }
    
    
    init(name:String,ID:Int) {
        self._name = name
        self._pokID = ID
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokID!)/"
    }
    
    
    
    // function that downloads the pokemon remaining data from the pokeapi.co API
    func downloadPokemonDetails(oncomplete:@escaping ()->()){
        let session = URLSession.shared
        
        
        session.dataTask(with: URL(string:self._pokemonUrl!)!){ (data, response, error) in
            if let data = data{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("json data is \(jsonData)")
                    
                    if let realData = jsonData as? Dictionary<String, AnyObject>{
                        if let weight = realData["weight"] as? Int{
                            self._weight = "\(weight)"
                        }
                        if let types = realData["types"] as? [Dictionary<String, AnyObject>]{
                            if let type = types[0] as? Dictionary<String,AnyObject>, let type1 = type["type"] as? Dictionary<String, AnyObject>, let typeName = type1["name"] as? String{
                                self._type = typeName
                                print("type: \(typeName)")
                            }
                        }
                        if let stats = realData["stats"] as? [Dictionary<String, AnyObject>]{
                            if !stats[3].isEmpty {
                                if let defenseValue = (stats[3])["base_stat"] as? Int{
                                    self._defense = "\(defenseValue)"
                                }
                            }
                            
                            if !stats[4].isEmpty{
                                if let attackValue = (stats[4])["base_stat"] as? Int{
                                    self._attack = "\(attackValue)"
                                }
                            }
                        }
                        if realData["height"] != nil{
                            self._height = "\(realData["height"]!)"
                        }
                        
                    }
                    oncomplete()
                    
                }catch{
                    let errorE = NSError()
                    print("exception error: \(errorE.debugDescription)")
                }
            }else{
                print("error getting data")
            }
            }
        
        
    }
}
