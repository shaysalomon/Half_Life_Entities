//
//  EntitiesViewController.swift
//  HalfLifeEntities
//
//  Created by Shay Salomon on 07/08/2016.
//  Copyright © 2016 mainqueue. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


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
    
    var entities = [HalfLifeEntity]()
    
    
    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Private Vars
    //----------------------------------------------------------------------
    
    var audioPlayer: AVAudioPlayer!
    

    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Life Cycle
    //----------------------------------------------------------------------
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.remembersLastFocusedIndexPath = true
        
        // add recognizer for play/pause button
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
        
        loadEntities()
    }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //----------------------------------------------------------------------
    // MARK: - Actions
    //----------------------------------------------------------------------
    
    
    @IBAction func actionPlayAudio(sender: UIButton) {
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            let entity = entities[selectedIndexPath.row]
            
            playAudio(forEntity: entity)
        }
    }
    
}





//----------------------------------------------------------------------
// MARK: - Helpers
//----------------------------------------------------------------------

extension EntitiesViewController {
    
    
    func loadEntities() {
        
        guard let path = NSBundle.mainBundle().pathForResource("Half_Life_Entities", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            
            return
        }
        
        for json in dataArray {
            
            let greeting = HalfLifeEntity(json: json as! [String : AnyObject])
            entities.append(greeting!)
        }
        
        entities.sortInPlace {
            
             $0.title < $1.title
        }
    }
    
    
    
    func update(withEntity entity: HalfLifeEntity) {
        
        imageView.image = UIImage(named: entity.imageFileName)!
    }
    
    
    
    func playAudio(forEntity entity: HalfLifeEntity) {
        
        let audioPath:NSURL = NSBundle.mainBundle().URLForResource(entity.audioFileName, withExtension: "wav")!
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioPath, fileTypeHint: nil)
            audioPlayer.play()
            
        } catch {
            
            return
        }
    }
    
    
    func playVideo() {
        
        let localPath = NSBundle.mainBundle().pathForResource("portal-2-teaser-trailer", ofType: "mp4")
        
        let videoAddress:NSURL = NSURL.fileURLWithPath(localPath!)
        
        let player = AVPlayer(URL:videoAddress)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        presentViewController(playerViewController, animated: true) {
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entities.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EntitiesCell", forIndexPath: indexPath)
        
        let halfLifeEntity = entities[indexPath.row]
        cell.textLabel?.text = halfLifeEntity.title
        
        return cell
    }
}





//----------------------------------------------------------------------
// MARK: - UITableViewDelegate
//----------------------------------------------------------------------

extension EntitiesViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        setNeedsFocusUpdate()
    }
    
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        guard let highlightedRow = context.nextFocusedIndexPath?.row  else {
            
            return
        }
                
        let halfLifeEntity = entities[highlightedRow]
        update(withEntity: halfLifeEntity)
        
        if let row = tableView.indexPathForSelectedRow {
            
            tableView.deselectRowAtIndexPath(row, animated: false)
        }
    }
    
}