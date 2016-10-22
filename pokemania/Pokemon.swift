//
//  Pokemon.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//
import UIKit
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
    var description:String{
        get{
            return _description
        }
    }
    
    init(name:String,ID:Int) {
        self._name = name
        self._pokID = ID
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokID!)/"
        
    }
    
    
    
    // function that downloads the pokemon remaining data from the pokeapi.co API
    func downloadPokemonDetails(oncomplete: @escaping ()->()){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // first session to get the core data of the pokemon like atk,def..etc
        session.dataTask(with: URL(string: self._pokemonUrl)!) { (data, response, error) in
            
            if error != nil{
                print("Error geting Data")
            }else{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    NSLog("\(jsonData)")
                    
                    if let realData = jsonData as? Dictionary<String, AnyObject>{
                        if let weight = realData["weight"] as? Int{
                            self._weight = "\(weight)"
                        }
                        if let types = realData["types"] as? [Dictionary<String, AnyObject>]{
                            if let type1 = types[0]["type"] as? Dictionary<String, AnyObject>, let typeName = type1["name"] as? String{
                                self._type = typeName
                                print("type: \(typeName)")
                            }
                        }
                        if let stats = realData["stats"] as? [Dictionary<String, Any>]{
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
                        
                        
                        
                        // second dataTask to get the description of the pokemon
                        session.dataTask(with: URL(string: "\(URL_BASE)\(URL_DESCRIPTION)\(self._pokID!)/")!, completionHandler: { (dataDesc, responseDesk, errorDesk) in
                            
                            if errorDesk == nil{
                                
                                do{
                                    let Desc = try JSONSerialization.jsonObject(with: dataDesc!, options: .allowFragments)
                                        
                                    if let realDesc = Desc as? [String: AnyObject]{
                                        if let pokemonDesc = realDesc["description"] as? String{
                                            self._description = pokemonDesc
                                        }
                                    }
                                }catch{
                                    
                                }
                            
                            }else{
                                self._description = "No description found!"
                            }
                            
                            oncomplete()
                        }).resume()
                        
                    }
                    
                    
                    
                }catch{
                    print("exception has been occured")
                }
            }
            
            
        }.resume()
        
        
    }
}




