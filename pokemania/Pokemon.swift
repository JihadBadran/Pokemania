//
//  Pokemon.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//
import UIKit
import Foundation
import CoreData
class Pokemon{
    private var _name:String!
    private var _pokID:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String = ""
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionText:String!
    private var _pokemonUrl:String!
    
    var name:String{
        get{
            return _name
        }set{
            self._name = newValue
        }
    }
    var poID:Int{
        get{
            return _pokID
        }set{
            self._pokID = newValue
        }
    }
    var defense:String{
        get{
            return _defense
        }set{
            self._defense = newValue
        }
    }
    var type:String{
        get{
            return _type
        }set{
            self._type = newValue
        }
    }
    var height:String{
        get{
            return _height
        }set{
            self._height = newValue
        }
    }
    var weight:String{
        get{
            return _weight
        }set{
            self._weight = newValue
        }
    }
    var attack:String{
        get{
            return _attack
        }set{
            self._attack = newValue
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
        }set{
            self._description = newValue
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
        
        print("the id of this man is \(self._pokID)")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        
        
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
                                
                                
                                self.newData(context!, entity: "Pokemon", desc: self._description, type: self._type, defense: self._type, attack: self._attack, height: self._height, weight: self._weight)
                                
                                oncomplete()
                            }).resume()
                            
                        }
                        
                        
                        
                    }catch{
                        print("exception has been occured")
                    }
                }
                
                
                }.resume()
        
    }
    
    
    
    
    
    private func newData(_ context: NSManagedObjectContext,entity:String, desc:String, type:String, defense:String, attack:String, height:String, weight:String){
        
        for result in fetchData(context, entity:"Pokemon") as! [NSManagedObject]{
            if let name = result.value(forKey: "name") as? String{
                if self._name == name{
                    result.setValue(self._pokID, forKey: "id")
                    result.setValue(self._name, forKey: "name")
                    result.setValue(desc, forKey: "desc")
                    result.setValue(type, forKey: "type")
                    result.setValue(defense, forKey: "defense")
                    result.setValue(attack, forKey: "attack")
                    result.setValue(height, forKey: "height")
                    result.setValue(weight, forKey: "weight")
                    
                    do{
                        try context.save()
                        print("saved on exist")
                    }catch{
                        print("error saving")
                    }
                    return
                }
            }
        }
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: entity, into: context)
        newUser.setValue(self._pokID, forKey: "id")
        newUser.setValue(self._name, forKey: "name")
        newUser.setValue(desc, forKey: "desc")
        newUser.setValue(type, forKey: "type")
        newUser.setValue(defense, forKey: "defense")
        newUser.setValue(attack, forKey: "attack")
        newUser.setValue(height, forKey: "height")
        newUser.setValue(weight, forKey: "weight")
        
        do{
            try context.save()
            print("saved as new")
        }catch{
            print("error saving")
        }
    }
    
    private func fetchData(_ context:NSManagedObjectContext, entity:String) -> [AnyObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        
        
        do{
            let results = try context.fetch(request)
            
            return results as [AnyObject]
        }catch{
            return []
        }
    }
}




