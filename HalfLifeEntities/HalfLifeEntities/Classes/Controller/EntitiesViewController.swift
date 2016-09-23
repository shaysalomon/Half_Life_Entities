//
//  EntitiesViewController.swift
//  HalfLifeEntities
//
//  Created by Shay Salomon on 07/08/2016.
//  Copyright © 2016 mainqueue. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



class EntitiesViewController: UIViewController {
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Outlets
    //----------------------------------------------------------------------
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Data Source
    //----------------------------------------------------------------------
    
    // The model of this controller.
    // Array of HalfLifeEntity.
    fileprivate var entities = [HalfLifeEntity]()
    
    
    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Private Vars
    //----------------------------------------------------------------------
    
    // For playing the entities audio lines.
    fileprivate var audioPlayer: AVAudioPlayer!
    

    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Life Cycle
    //----------------------------------------------------------------------
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remember last cell focus after leaving the table view.
        tableView.remembersLastFocusedIndexPath = true
        
        // Add recognizer for play/pause button
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue as Int)]
        self.view.addGestureRecognizer(tapRecognizer)
        
        // Load the data for this controller
        loadEntities()
    }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Actions
    //----------------------------------------------------------------------
    
    // Play audio action
    @IBAction func actionPlayAudio(_ sender: UIButton) {
        
        // If there is a selected entity, play audio.
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            let entity = entities[(selectedIndexPath as NSIndexPath).row]
            
            playAudio(forEntity: entity)
        }
    }
    
}





//----------------------------------------------------------------------
// MARK: - Helpers
//----------------------------------------------------------------------

extension EntitiesViewController {
    
    
    // Load the half life entities data from the plist in the bundle.
    fileprivate func loadEntities() {
        
        // Load data from plist to array
        guard let path = Bundle.main.path(forResource: "Half_Life_Entities", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            
            return
        }
        
        // Normalize to model array
        for json in dataArray {
            
            let greeting = HalfLifeEntity(json: json as! [String : AnyObject])
            entities.append(greeting!)
        }
        
        // Sort the array by "title"
        entities.sort {
            
             $0.title < $1.title
        }
    }
    
    
    // Update the UI with an Half Life Entity
    fileprivate func update(withEntity entity: HalfLifeEntity) {
        
        // Update the image view
        imageView.image = UIImage(named: entity.imageFileName)!
    }
    
    
    // Play the audio for an Entity
    fileprivate func playAudio(forEntity entity: HalfLifeEntity) {
        
        let audioPath:URL = Bundle.main.url(forResource: entity.audioFileName, withExtension: "wav")!
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath, fileTypeHint: nil)
            audioPlayer.play()
            
        } catch {
            
            return
        }
    }
    
    // Play the portal 2 video
    func playVideo() {
        
        // Path of video
        let localPath = Bundle.main.path(forResource: "portal-2-teaser-trailer", ofType: "mp4")
        
        let videoAddress:URL = URL(fileURLWithPath: localPath!)
        
        let player = AVPlayer(url:videoAddress)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
    
    override var preferredFocusedView: UIView? {
      
        return playAudioButton
    }
}







//----------------------------------------------------------------------
// MARK: - UITableViewDataSource
//----------------------------------------------------------------------

extension EntitiesViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntitiesCell", for: indexPath)
        
        let halfLifeEntity = entities[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = halfLifeEntity.title
        
        return cell
    }
}







//----------------------------------------------------------------------
// MARK: - UITableViewDelegate
//----------------------------------------------------------------------

extension EntitiesViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setNeedsFocusUpdate()
    }
    
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        // Check if a cell is focused / highlighted, because this method is called also when other views are focused.
        guard let highlightedRow = (context.nextFocusedIndexPath as NSIndexPath?)?.row  else {
            
            return
        }
                
        let halfLifeEntity = entities[highlightedRow]
        update(withEntity: halfLifeEntity)
        
        if let row = tableView.indexPathForSelectedRow {
            
            tableView.deselectRow(at: row, animated: false)
        }
    }
    
}
