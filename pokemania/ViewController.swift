//
//  ViewController.swift
//  pokemania
//
//  Created by Jihad Badran on 7/19/16.
//  Copyright © 2016 Jihad Badran. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView:UICollectionView!
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        parseCSV()
        
        initAudio()
    }
    func initAudio(){
        let file = Bundle.main.pathForResource("sound", ofType: "mp3")
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file!))
            musicPlayer.prepareToPlay()
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
        let path = Bundle.main.pathForResource("pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokid = Int(row["id"]!)!
                let pokname = String(row["identifier"]!)
                let pokemon = Pokemon(name: pokname, ID: pokid)
                DataService.instance.insert(pokemon: pokemon)
            }
        }catch{
            let err = NSError()
            print(err.localizedFailureReason)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.data.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // configuring the cell and put it in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokcell", for: indexPath) as? pokemonCellVC{
            
            let pokemon = DataService.instance.data[indexPath.row]
            cell.configureCell(pokemon: pokemon)
            return cell
        }else{
            let cell = UICollectionViewCell()
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: 90)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

