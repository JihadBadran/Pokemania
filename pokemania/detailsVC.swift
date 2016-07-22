//
//  detailsVC.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import UIKit

class detailsVC: UIViewController {
    
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var idLabel:UILabel!
    @IBOutlet weak var mainImage:UIImageView!
    @IBOutlet weak var attackLabel:UILabel!
    @IBOutlet weak var defenseLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var heightLabel:UILabel!
    @IBOutlet weak var weightLabel:UILabel!
    
    
    
    var pokemon:Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.nameLabel.text = "\(pokemon.name.uppercased())"
        self.idLabel.text = "ID:\(pokemon.poID)"
        self.mainImage.image = UIImage(named: "\(pokemon.poID)")
        
        
        self.pokemon.downloadPokemonDetails {
            print("did we get here?")
            
            DispatchQueue.main.async(execute: {
                self.updateUI()
            })
            
        }
        
    }
    func updateUI(){
        attackLabel.text = "Attack:\(pokemon.attack)"
        defenseLabel.text = "Defense:\(self.pokemon.defense)"
        typeLabel.text = "Type:\(self.pokemon.type)"
        heightLabel.text = "Height:\(self.pokemon.height)"
        weightLabel.text = "Weight:\(self.pokemon.weight)"
        
        
    }
    
    @IBAction func backBtnPressed(sender:AnyObject){
        dismiss(animated: true, completion: nil)
    }
    

}
