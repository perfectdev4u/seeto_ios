//
//  VideoPlayerCollViewCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit
import AVFoundation

class VideoPlayerCollViewCell: UICollectionViewCell {
   var playerViewAV = AVPlayerLayer()
    public var isPlaying: Bool = false
    let screenSize: CGRect = UIScreen.main.bounds
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }
    
    func configureWithUrl(_ url : URL?)
    {
        if let url = url
        {
            let avPlayer = AVPlayer(url: url)
            
            playerViewAV.player = avPlayer
            playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height: screenSize.height - 172)
            playerViewAV.videoGravity = AVLayerVideoGravity.resize
            contentView.layer.addSublayer( playerViewAV)
        }    }
    public func startPlaying() {
        playerViewAV.player?.play()
           isPlaying = true
       }
       
       public func stopPlaying() {
           playerViewAV.player?.pause()
           isPlaying = false
       }
    override func prepareForReuse() {
        stopPlaying()
    }
}
