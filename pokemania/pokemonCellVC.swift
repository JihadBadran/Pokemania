//
//  pokemonCellVC.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import UIKit

class pokemonCellVC: UICollectionViewCell {
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var thumbnail:UIImageView!
    var pokemon:Pokemon!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(pokemon:Pokemon){
        self.pokemon = pokemon
        self.titleLbl.text = self.pokemon.name.capitalized
        self.thumbnail.image = UIImage(named: "\(self.pokemon.poID)")
    }
    
}
