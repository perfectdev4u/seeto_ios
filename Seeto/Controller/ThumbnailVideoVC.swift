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
    let videoUrl = ""
    var updateVideo = false
    var dictParam = [:] as [String : Any]
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
        DispatchQueue.main.async {
            if sender.image(for: .normal) == UIImage(named: "pause")
            {
                sender.setImage( UIImage(named: "play"), for: .normal)

                self.playerViewAV.player?.pause()
            }
            else
            {
                sender.setImage( UIImage(named: "pause"), for: .normal)
                self.playerViewAV.player?.play()
            }
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

                DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                    print("done")
                  
                    self.uploadImage(paramName: "file", fileName: "thumbImg.png", image: UIImage(cgImage: thumb).resizeWithPercent(percentage: 0.5)!)
                   // self.thumbImg = true
                 //   self.imgThumbnail.image = UIImage(cgImage: thumb)
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//                    self.navigationController?.pushViewController(vc, animated: true)
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
    
    func updateCandidateProfileApi()
    {
       
       
        ApiManager().postRequest(parameters: dictParam,api:  ApiManager.shared.UpdateCandidateProfile) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    
                    self.showToast(message: error.localizedDescription)
                }
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                if let dict = dataJson["data"] as? NSDictionary{
                  }
                  print(dataJson)
                  UserDefaults.standard.set(2, forKey: "userType")

                  DispatchQueue.main.async {
                      if self.updateVideo == true
                      {
                          self.navigationController?.popViewController(animated: true)
                      }
                      else
                      {
                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobSearchesVC") as! MyJobSearchesVC
                          vc.fromHome = true
                          self.navigationController?.pushViewController(vc, animated: true)
                      }
                  }

                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:"Erro", controller: self)
                    }

                }
                
            }

            }
        }
    }

    
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "http://34.207.158.183/api/v1.0/User/UploadFile")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                if let json = jsonData as? [String: Any] {
                    if let dict = json["data"] as? NSDictionary{
                        self.dictParam["thumbnailUrl"] = (dict["url"] as? String) ?? ""
                        DispatchQueue.main.async {
                            
                            SwiftLoader.hide()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.updateCandidateProfileApi()
                        }
                      }
                    print(json)

                }
                DispatchQueue.main.async {
                    
                    SwiftLoader.hide()
                }

            }
            else
            {
                DispatchQueue.main.async {
                    
                    SwiftLoader.hide()
                }
                print(error?.localizedDescription)
            }
        }).resume()
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

