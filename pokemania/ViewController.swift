//
//  ViewController.swift
//  pokemania
//
//  Created by Jihad Badran on 7/19/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!
    var musicPlayer: AVAudioPlayer!
    
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        parseCSV()
        searchBar.delegate = self
        initAudio()
        
        
        
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collectionView.reloadData()
        }else{
            inSearchMode = true
            DataService.instance.filteredArray = DataService.instance.data.filter({ (pok:Pokemon) -> Bool in
                if pok.name.lowercased().contains(searchText.lowercased()){
                    
                    return true
                }else{
                    return false
                }
            })
            collectionView.reloadData()
        }
        
    }
    
    
    func initAudio(){
        let file = Bundle.main.path(forResource: "sound", ofType: "mp3")
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file!))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch{
            let err = NSError()
            print(err.localizedFailureReason)
        }
    }
    
    
    
    @IBAction func pauseBtnClicked(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.setTitle("Play", for: .normal)
        }else{
            musicPlayer.play()
            sender.setTitle("Pause", for: .normal)
        }
        
        
    }
    func parseCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokid = Int(row["id"]!)!
                let pokname = String(row["identifier"]!)
                let pokemon = Pokemon(name: pokname!, ID: pokid)
                DataService.instance.insert(pokemon: pokemon)
            }
        }catch{
            let err = NSError()
            print(err.localizedFailureReason)
        }
        
    }
    
    // clicked on collection view cell event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pokemon:Pokemon
        if inSearchMode{
            pokemon = DataService.instance.filteredArray[indexPath.row]
        }else{
            pokemon = DataService.instance.data[indexPath.row]
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.autoreverse, animations: {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }, completion: {(true) -> () in
                collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        })
        
        performSegue(withIdentifier: "goToDetails", sender: pokemon)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return DataService.instance.filteredArray.count
        }else{
            return DataService.instance.data.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // configuring the cell and put it in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokcell", for: indexPath) as? pokemonCellVC{
            var pokemon:Pokemon
            if inSearchMode{
                pokemon = DataService.instance.filteredArray[indexPath.row]
                cell.configureCell(pokemon: pokemon)
            }else{
                pokemon = DataService.instance.data[indexPath.row]
                cell.configureCell(pokemon: pokemon)
            }
            return cell
        }else{
            let cell = UICollectionViewCell()
            return cell
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? detailsVC{
            if let pokemon = sender as? Pokemon{
                view.pokemon = pokemon
            }
        }
    }


}

