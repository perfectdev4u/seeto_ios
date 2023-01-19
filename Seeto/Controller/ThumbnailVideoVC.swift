//
//  ThumbnailVideoVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 10/01/23.
//

import UIKit
import AVFoundation
import SwiftLoader
class ThumbnailVideoVC: UIViewController {
    @IBOutlet var viewMain: UIView!
    var urlVideo = URL.init(string: "")
    @IBOutlet var btnCheck: UIButton!
    let screenSize: CGRect = UIScreen.main.bounds
    var playerViewAV = AVPlayerLayer()
    @IBOutlet weak var btnDone: UIButton!
    var avPlayer = AVPlayer()
    @IBOutlet var imgThumbnail: UIImageView!
    let btnPlayPause = UIButton()
    let btnBackward = UIButton()
    let btnForward = UIButton()
    var finished = false
    let videoUrl = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCheck.layer.cornerRadius = btnCheck.frame.height / 2
        btnDone.layer.cornerRadius = 12
        if let url = urlVideo
        {
            avPlayer = AVPlayer(url: url)
            playerViewAV.player = avPlayer
            playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height:viewMain.frame.height)
            btnPlayPause.frame = CGRect(x: ((screenSize.width - 20) / 2) - 40, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
            btnPlayPause.layer.cornerRadius = btnPlayPause.frame.height / 2
            btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
            btnPlayPause.setShadowButton()
            btnPlayPause.addTarget(self, action: #selector(playPauseBtn), for: .touchUpInside)
            
            btnBackward.frame = CGRect(x: 15, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
            btnBackward.layer.cornerRadius = btnPlayPause.frame.height / 2
            btnBackward.setImage(UIImage(named: "backward"), for: .normal)
            btnBackward.addTarget(self, action: #selector(btnBackwardAction), for: .touchUpInside)

            btnForward.frame = CGRect(x: ((screenSize.width - 10)) - 100, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
            btnForward.layer.cornerRadius = btnPlayPause.frame.height / 2
            btnForward.setImage(UIImage(named: "forward"), for: .normal)
            btnForward.addTarget(self, action: #selector(btnForwardAction), for: .touchUpInside)

            playerViewAV.videoGravity = AVLayerVideoGravity.resize
            viewMain.layer.addSublayer(playerViewAV)
          //  viewMain.layer.cornerRadius = 40
            viewMain.addSubview(btnPlayPause)
            viewMain.addSubview(btnBackward)
            viewMain.addSubview(btnForward)
            playerViewAV.player?.play()

            NotificationCenter.default.addObserver(self, selector: #selector(ThumbnailVideoVC.didfinishplaying),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewAV.player?.currentItem)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFbAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    @IBAction func btnActShowImage(_ sender: UIButton) {
        if self.thumbImg == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageVC
            vc.image = imgThumbnail.image!
            self.present(vc, animated: true)
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
    var thumbImg = false
    func screenshot() {
        if let url = (playerViewAV.player?.currentItem?.asset as? AVURLAsset)?.url {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.requestedTimeToleranceAfter = CMTime.zero
            imageGenerator.requestedTimeToleranceBefore=CMTime.zero
            imageGenerator.appliesPreferredTrackTransform = true
            if let thumb: CGImage = try? imageGenerator.copyCGImage(at: (playerViewAV.player?.currentTime())!,actualTime: nil) {
                //print("video img successful")
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    print("done")
                   // self.thumbImg = true
                 //   self.imgThumbnail.image = UIImage(cgImage: thumb)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
            else
            {
                SwiftLoader.hide()
            }
        }
        else
        {
            SwiftLoader.hide()
        }
    }
    @IBAction func btnClickVideoPic(_ sender: UIButton) {
        print("entered")
        SwiftLoader.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            self.screenshot()
        }
    }
    
    @objc func btnForwardAction(_ sender: UIButton) {
        guard let duration = playerViewAV.player?.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds((playerViewAV.player?.currentTime())!)
        let newTime = currentTime + 5.0
        if newTime < (CMTimeGetSeconds(duration) - 5.0){
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            playerViewAV.player?.seek(to: time)
        }
    }
    @objc  func btnBackwardAction(_ sender: UIButton) {

        let currentTime = CMTimeGetSeconds((playerViewAV.player?.currentTime())!)
        var newTime = currentTime - 5.0

        if newTime < 0{
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        playerViewAV.player?.seek(to: time)

    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

