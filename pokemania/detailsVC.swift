//
//  detailsVCViewController.swift
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
    
    var pokemon:Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.nameLabel.text = pokemon.name.uppercased()
        self.idLabel.text = "ID:\(pokemon.poID)"
        self.mainImage.image = UIImage(named: "\(pokemon.poID)")
    }
    
    
    @IBAction func backBtnPressed(sender:AnyObject){
        dismiss(animated: true, completion: nil)
    }
    

}
