//
//  ResumeVideoPreviewVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 10/02/23.
//

import UIKit
import AVFoundation
import SwiftLoader
class ResumeVideoPreviewVC: UIViewController {

    @IBOutlet var viewMain: UIView!
    var urlVideo = URL.init(string: "")
    let screenSize: CGRect = UIScreen.main.bounds
    var playerViewAV = AVPlayerLayer()
    var avPlayer = AVPlayer()
    let btnPlayPause = UIButton()
    let btnBackward = UIButton()
    let btnForward = UIButton()
    var finished = false
    let videoUrl = ""
    var updateVideo = false
    var dictParam = [:] as [String : Any]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = urlVideo
        {
            avPlayer = AVPlayer(url: url)
            playerViewAV.player = avPlayer
            playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height:viewMain.frame.height)
            playerViewAV.videoGravity = AVLayerVideoGravity.resize
            viewMain.layer.addSublayer(playerViewAV)
          //  viewMain.layer.cornerRadius = 40
            viewMain.addSubview(btnPlayPause)
            viewMain.addSubview(btnBackward)
            viewMain.addSubview(btnForward)
            playerViewAV.player?.play()
            SwiftLoader.show(animated: true);
            playerViewAV.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(ThumbnailVideoVC.didfinishplaying),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewAV.player?.currentItem)
        }
        // Do any additional setup after loading the view.
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                if #available(iOS 10.0, *) {
                    let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                    let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                    if newStatus != oldStatus {
                       DispatchQueue.main.async {[weak self] in
                           if newStatus == .playing || newStatus == .paused {
                               SwiftLoader.hide()
                           } else {
                               SwiftLoader.show(animated: true);
                           }
                       }
                    }
                } else {
                    // Fallback on earlier versions
                    SwiftLoader.hide()
                }
            }
        }
    
    @objc func didfinishplaying()
    {
        print("Finished")
        finished = true
        playerViewAV.player?.seek(to: CMTime.zero)

        btnPlayPause.setImage( UIImage(named: "play"), for: .normal)

    }
    @objc func playPauseBtn(_ sender : UIButton)
    {
        if sender.image(for: .normal) == UIImage(named: "pause")
        {
            sender.setImage( UIImage(named: "play"), for: .normal)

            playerViewAV.player?.pause()
        }
        else
        {
            sender.setImage( UIImage(named: "pause"), for: .normal)
            playerViewAV.player?.play()
        }
    }
    

    
    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
