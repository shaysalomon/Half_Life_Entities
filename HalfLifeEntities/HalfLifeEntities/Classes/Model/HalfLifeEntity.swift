//
//  HalfLifeEntity.swift
//  HalfLifeEntities
//
//  Created by Shay Salomon on 08/08/2016.
//  Copyright © 2016 mainqueue. All rights reserved.
//

import Foundation



struct HalfLifeEntity {
    
    
    var title:          String
    var imageFileName:  String
    var audioFileName:  String
    
    
    init?(json: [String: AnyObject]) {
        
        guard let title = json["title"] as? String,
            imageFileName = json["imageFileName"] as? String,
            audioFileName = json["audioFileName"] as? String else {
                
                return nil
        }
        
        self.title = title
        self.imageFileName = imageFileName
        self.audioFileName = audioFileName
    }
}