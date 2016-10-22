//
//  detailsVC.swift
//  pokemania
//
//  Created by Jihad Badran on 7/20/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import UIKit
import MapKit
class detailsVC: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var mainImage:UIImageView!
    @IBOutlet weak var attackLabel:UILabel!
    @IBOutlet weak var defenseLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var heightLabel:UILabel!
    @IBOutlet weak var weightLabel:UILabel!
    @IBOutlet weak var descLabel:UITextView!
    
    
    var pokemon:Pokemon!
    var loadingView:UIView!
    var loadingindecator:UIActivityIndicatorView!
    var loadingLabel:UILabel!
    
    var map:MKMapView!
    @IBOutlet weak var mapContainer:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = MKMapView()
        map.delegate = self
        mapContainer.addSubview(map)
        
        
        
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        loadingView.layer.cornerRadius = 5.0
        loadingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loadingView.alpha = 0.8
        
        
        loadingindecator = UIActivityIndicatorView()
        loadingView.addSubview(loadingindecator)
        loadingindecator.center = loadingView.center
        loadingindecator.startAnimating()
        
        loadingLabel = UILabel(frame: CGRect(x: 0, y: loadingView.center.y + loadingindecator.frame.height+10, width: 200, height: 25))
        loadingLabel.text = "LOADING..."
        loadingLabel.textColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        loadingLabel.textAlignment = .center
        loadingView.addSubview(loadingLabel)
        
        self.view.addSubview(loadingView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.nameLabel.text = "\(pokemon.name.uppercased())"
        self.mainImage.image = UIImage(named: "\(pokemon.poID)")
        loadingView.center = self.view.center
        loadingView.isHidden = false
        map.frame = CGRect(x: 0, y: 0, width: 360, height: 300)
        
        
        self.pokemon.downloadPokemonDetails {
            print("did we get here?")
            DispatchQueue.main.async(execute: {
                self.updateUI()
                self.loadingView.isHidden = true
            })
        }
        
    }
    func updateUI(){
        attackLabel.text = "\(pokemon.attack)"
        defenseLabel.text = "\(self.pokemon.defense)"
        typeLabel.text = "\(self.pokemon.type.capitalized)"
        heightLabel.text = "\(self.pokemon.height)"
        weightLabel.text = "\(self.pokemon.weight)"
        descLabel.text = "\(self.pokemon.description)"
        
    }
    
    @IBAction func backBtnPressed(sender:AnyObject){
        dismiss(animated: true, completion: nil)
    }
    

}
