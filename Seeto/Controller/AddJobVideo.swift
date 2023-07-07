//
//  AddJobVideo.swift
//  Seeto
//
//  Created by Paramveer Singh on 18/02/23.
//

import UIKit
import AVFoundation
import SwiftLoader

class AddJobVideo: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet var sliderMain: UISlider!
    @IBOutlet var imgMain: UIImageView!
    @IBOutlet var collView: UICollectionView!
   var jobId = -1
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
    var jobDelegate : JobDelegate!
    var asset: AVAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var imageGenerator: AVAssetImageGenerator?
    var images = [UIImage]()
    var timer: Timer?
    let scrollView = UIScrollView()
    var imageViews = [UIImageView]()
   var fromHome = false
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCheck.layer.cornerRadius = btnCheck.frame.height / 2
        btnDone.layer.cornerRadius = 12
        collView.backgroundColor = .clear
        collView.showsHorizontalScrollIndicator = false
        collView.contentInsetAdjustmentBehavior = .never
        collView.delegate = self
        collView.dataSource = self
        collView.layer.cornerRadius = 8
        collView.layer.borderWidth = 2
        collView.layer.borderColor = blueButtonColor.cgColor
        imagePicker.delegate = self
        if let url = urlVideo
        {
            asset = AVAsset(url: url)
            // Set the frame and content mode of the image view
            scrollView.frame = CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 70)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.contentInsetAdjustmentBehavior = .never
            view.addSubview(scrollView)
        // Create the player item and player
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem!)
        
        // Create the image generator
        imageGenerator = AVAssetImageGenerator(asset: asset!)
        imageGenerator?.appliesPreferredTrackTransform = true
        
        // Generate the thumbnail images at 1 second intervals
        let durationSeconds = CMTimeGetSeconds(asset!.duration)
            print("Duration: \(durationSeconds) seconds")

        let intervalSeconds = 1.0
        var time = CMTime.zero
        while (CMTimeGetSeconds(time) < durationSeconds) {
            print("Time: \(CMTimeGetSeconds(time)) seconds")

            if let image = generateThumbnailImage(time: time) {
                images.append(image)
            }
            time = CMTimeMakeWithSeconds(CMTimeGetSeconds(time) + intervalSeconds, preferredTimescale: 1000)
        }
            for image in images {
                      let imageView = UIImageView(image: image)
                      imageView.contentMode = .scaleAspectFit
                      scrollView.addSubview(imageView)
                      imageViews.append(imageView)
                  }
            for i in 0..<imageViews.count {
                       imageViews[i].translatesAutoresizingMaskIntoConstraints = false
                       imageViews[i].topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                       imageViews[i].bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                       imageViews[i].widthAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
                       if i == 0 {
                           imageViews[i].leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                       } else {
                           imageViews[i].leadingAnchor.constraint(equalTo: imageViews[i-1].trailingAnchor).isActive = true
                       }
                       if i == imageViews.count - 1 {
                           imageViews[i].trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                       }
                   }
        // Configure the image slider
       sliderMain.maximumValue = Float(images.count - 1)
            sliderMain.value = 0
        imgMain.image = images[0]
            print("Number of images: \(images.count)")
            DispatchQueue.main.async {
                self.collView.reloadData()

            }
                }

      //  if let url = urlVideo
//        {
//            avPlayer = AVPlayer(url: url)
//            playerViewAV.player = avPlayer
//            playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height:viewMain.frame.height)
//            btnPlayPause.frame = CGRect(x: ((screenSize.width - 20) / 2) - 40, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
//            btnPlayPause.layer.cornerRadius = btnPlayPause.frame.height / 2
//            btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
//            btnPlayPause.setShadowButton()
//            btnPlayPause.addTarget(self, action: #selector(playPauseBtn), for: .touchUpInside)
//
//            btnBackward.frame = CGRect(x: 15, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
//            btnBackward.layer.cornerRadius = btnPlayPause.frame.height / 2
//            btnBackward.setImage(UIImage(named: "backward"), for: .normal)
//            btnBackward.addTarget(self, action: #selector(btnBackwardAction), for: .touchUpInside)
//
//            btnForward.frame = CGRect(x: ((screenSize.width - 10)) - 100, y: ((viewMain.frame.height) / 2) - 40, width: 80, height: 80)
//            btnForward.layer.cornerRadius = btnPlayPause.frame.height / 2
//            btnForward.setImage(UIImage(named: "forward"), for: .normal)
//            btnForward.addTarget(self, action: #selector(btnForwardAction), for: .touchUpInside)
//
//            playerViewAV.videoGravity = AVLayerVideoGravity.resize
//            viewMain.layer.addSublayer(playerViewAV)
//          //  viewMain.layer.cornerRadius = 40
//            viewMain.addSubview(btnPlayPause)
//            viewMain.addSubview(btnBackward)
//            viewMain.addSubview(btnForward)
//            playerViewAV.player?.play()
//
//            NotificationCenter.default.addObserver(self, selector: #selector(ThumbnailVideoVC.didfinishplaying),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewAV.player?.currentItem)
//        }
        // Do any additional setup after loading the view.
    }
    func generateThumbnailImage(time: CMTime) -> UIImage? {
        do {
            let imageGenerator = AVAssetImageGenerator(asset: asset!)
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1, timescale: 15)
            imageGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1, timescale: 15)

            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            print(cgImage) // print the CGImage to see if it's the same image
            return UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    @IBAction func btnFbAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    @IBAction func btnActShowImage(_ sender: UIButton) {
        cameraGallery()
        
    }
    func cameraGallery()
   {
       
       let alert = UIAlertController(title: "Choose Thumbnail from Gallery", message: nil, preferredStyle: .alert)
      
       alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
           self.openGallary()
       }))
       
       alert.addAction(UIAlertAction.init(title: "No", style: .destructive, handler: nil))
       
       /*If you want work actionsheet on ipad
       then you have to use popoverPresentationController to present the actionsheet,
       otherwise app will crash on iPad */
       switch UIDevice.current.userInterfaceIdiom {
       case .pad:
           alert.popoverPresentationController?.sourceView = self.view
           alert.popoverPresentationController?.sourceRect = self.view.bounds
           alert.popoverPresentationController?.permittedArrowDirections = .up
       default:
           break
       }
       
       self.present(alert, animated: true, completion: nil)
   }
    let imagePicker = UIImagePickerController()

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.modalPresentationStyle = .fullScreen

        self.present(imagePicker, animated: true, completion: nil)
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

                DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                    print("done")
                    self.uploadImage(paramName: "file", fileName: "thumbImg.png", image: UIImage(cgImage: thumb).convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale))
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
    
    func AddJobsApi()
    {
    
        if self.fromHome == true
        {
            dictParam["jobId"] = jobId
        }
       
        ApiManager().postRequest(parameters: dictParam,api: fromHome == false ?  ApiManager.shared.AddJobs : ApiManager.shared.UpdateJob  ) { dataJson, error in
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
               
                  print(dataJson)
//                  UserDefaults.standard.set(2, forKey: "userType")
                  DispatchQueue.main.async {

                      if self.updateVideo == true
                      {
                          self.jobDelegate.JobDone()

                          self.navigationController?.popViewController(animated: true)
                      }
                      else
                      {
                          if let dict = dataJson["data"] as? NSDictionary{
                              self.GetAllCandidateByJobApi(dictTable: dict)
                            }
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

    func GetAllCandidateByJobApi(dictTable : NSDictionary)
    {
        
        var param = [
            "jobId":  dictTable["jobId"] as? Int ?? 0,
        ] as [String : Any]
        
        ApiManager().postRequest(parameters: param,api:  ApiManager.shared.GetAllCandidateByJob) { dataJson, error in
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
                 
                if let dictArray = dataJson["data"] as? [NSDictionary]{
                    DispatchQueue.main.async {
                        if dictArray.count == 0
                        {
                            Toast.show(message: "No match found for your job", controller: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.jobDelegate.JobDone()

                                self.navigationController?.popViewController(animated: true)

                            }

                        }
                        else
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                            vc.mainDataArray = dictArray
                            vc.inputArray = self.dictParam as NSDictionary
                            vc.searchJobId = String(describing: dictTable["jobId"] as AnyObject)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:errorMessage, controller: self)
                    }

                }
                
            }

            }
        }
    }

    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "http://34.207.158.183/api/v1.0/User/UploadFile")
        SwiftLoader.show(animated: true)

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
                        SwiftLoader.hide()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.AddJobsApi()

//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThumbnailVideoVC") as! ThumbnailVideoVC
//                            vc.urlVideo = URL(string: self.videoUrlString)
//                            vc.dictParam = self.updateCandidateProfileData()
//                            self.navigationController?.pushViewController(vc, animated: true)

                        }
                      }
                    print(json)

                }
                SwiftLoader.hide()

            }
            else
            {
                SwiftLoader.hide()

                print(error?.localizedDescription)
            }
        }).resume()
    }

    
    @IBAction func btnClickVideoPic(_ sender: UIButton) {
        print("entered")
        SwiftLoader.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            let targetSize = CGSize(width: 720, height: 1280)

            self.uploadImage(paramName: "file", fileName: "thumbImg.png", image: self.imgMain.image!.scalePreservingAspectRatio(targetSize: targetSize))

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
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let selectedIndex = Int(sliderMain.value)
        print(selectedIndex)
        imgMain.image = images[selectedIndex]
        let offset = CGPoint(x: CGFloat(sliderMain.value) * scrollView.contentSize.width / CGFloat(images.count - 1), y: 0)
        scrollView.setContentOffset(offset, animated: true)

    }
}

extension AddJobVideo : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView(image: images[indexPath.row])
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: (screenSize.width - CGFloat(20)) / CGFloat(images.count), height: collectionView.frame.height)
        cell.contentView.addSubview(imageView)
        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((screenSize.width - CGFloat(20)) / CGFloat(images.count)) , height: collectionView.frame.height)
    }
}

extension AddJobVideo {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
     
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            //            let photo = info[.phAsset] as? PHAsset
            //            DispatchQueue.main.async {
            //                self.tblCandidateProfile.reloadData()
            //            }
        print("entered")
        SwiftLoader.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            let targetSize = CGSize(width: 720, height: 1280)

            self.uploadImage(paramName: "file", fileName: "thumbImg.png", image: image.scalePreservingAspectRatio(targetSize: targetSize))

        }
        // Handle a movie capture
        
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
