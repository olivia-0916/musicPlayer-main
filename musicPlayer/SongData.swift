//
//  SongData.swift
//  musicPlayer
//
//  Created by Betty Pan on 2021/3/19.
//

import Foundation
import UIKit

class SongData {
    let songTitle:String
    let singer:String
    let albumImage:UIImage?
    let songUrl:URL
    
    init(songTitle:String,
         singer:String,
         albumImage:UIImage?,
         songUrl:URL){
        self.songTitle = songTitle
        self.singer = singer
        self.albumImage = albumImage
        self.songUrl = songUrl
    }
}

