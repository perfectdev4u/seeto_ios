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
    @IBOutlet var imgThumb: UIImageView!
    public var isPlaying: Bool = false
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    let screenSize: CGRect = UIScreen.main.bounds
    var showThumb = false
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            // Remove the player item observer and stop the player
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemNewAccessLogEntry, object: playerViewAV.player?.currentItem)
        stopPlaying()
        }
    func addObserverNotification()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidUpdatePlaybackStatus(_:)), name: .AVPlayerItemNewAccessLogEntry, object: playerViewAV.player?.currentItem)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerViewAV.player?.currentItem)
    }
    @objc func playerDidFinishPlaying(_ notification: Notification) {
          // Seek to the beginning and start playing again
        playerViewAV.player?.seek(to: CMTime.zero)
        playerViewAV.player?.play()
      }
    
    @objc func playerDidUpdatePlaybackStatus(_ notification: Notification) {
           guard let playerItem = notification.object as? AVPlayerItem else { return }
           
           if let accessLog = playerItem.accessLog(), let event = accessLog.events.last {
               if event.indicatedBitrate > 0 {
                   imgThumb?.isHidden = true
                   activityIndicator.stopAnimating()
               }
           }
       }
    func configureWithUrl(_ url : URL?)
    {
        if let url = url
        {
            let avPlayer = AVPlayer(url: url)
            
            playerViewAV.player = avPlayer
            playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height: screenSize.height - 172)
            playerViewAV.videoGravity = AVLayerVideoGravity.resizeAspectFill
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
   
}
