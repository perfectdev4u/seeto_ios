//
//  HomeScreenVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit
import AVFoundation
import SDWebImage
class HomeScreenVC: UIViewController, LikeDislikeDelegate, SearchDetailDelegate, CongratsDelegate {
    func showMatch() {
        
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobSearchDetailsVC") as! JobSearchDetailsVC
               vc.searchId = Int(searchJobId) ?? 0
                self.navigationController?.pushViewController(vc, animated: true)

            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateSearchDetailVC") as! CandidateSearchDetailVC
                vc.jobId = Int(searchJobId) ?? 0
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }
        let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
        cells.forEach { videoCell in

            if videoCell.isPlaying {
                videoCell.stopPlaying()
            }
        }
    }
   
    @IBOutlet var btnSearch: UIButton!
    func dataFromSearch(data: [NSDictionary], searchId: String) {
        mainDataArray = data
        self.searchJobId = searchId
        DispatchQueue.main.async {
            self.collViewVideos.reloadData()
        }
    }
    
   
    
    func dataLikeDislike(id: Int, isMatch: Bool, index: Int) {
        matchOrPassUser(Id: id, isMatch: isMatch, index: index)

    }
    
    var userType = 0
    
    
    @IBOutlet var collViewVideos: UICollectionView!
    let screenSize: CGRect = UIScreen.main.bounds
    var mainDataArray = [NSDictionary].init()
    var inputArray = NSDictionary.init()
   
    var searchJobId = ""
    var videoUrlArray = ["https://seetoapp.s3.us-east-1.amazonaws.com/7993d069-cb7e-4757-b15f-5d0d8684249e_IMG_0232.MP4","https://seetoapp.s3.us-east-1.amazonaws.com/b7d23127-881e-43d9-b05e-9beaeec7ae97_IMG_0240.MP4","https://seetoapp.s3.us-east-1.amazonaws.com/1b099973-730d-4346-bcd1-acb4487c878e_IMG_0226.MP4"]
   // var videoUrlArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collViewVideos.contentInsetAdjustmentBehavior = .never

        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            self.userType = userType
            if userType == 2
            {
                videoUrlArray = ["https://seetoapp.s3.us-east-1.amazonaws.com/6309cf17-1c9f-4ca4-83a6-3274e1506c17_IMG_0205.MP4","https://seetoapp.s3.us-east-1.amazonaws.com/934cc68e-594c-4129-9c77-a696cca99837_IMG_0206.MP4","https://seetoapp.s3.us-east-1.amazonaws.com/6577df53-b518-4599-b491-631799e631d2_IMG_0219.MP4"]
            }
            else
            {
                btnSearch.isHidden = false

            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        var indexArray = [Int]()
        for index in 0...mainDataArray.count - 1
        {
            if let url = URL(string: (mainDataArray[index]["videoUrl"] as? String ?? ""))
            {
                
            }
            else
            {
                indexArray.append(index)
            }
        }
        for i in indexArray
        {
            mainDataArray.remove(at: i)
        }
        //collViewVideos.layer.cornerRadius = 40
        collViewVideos.delegate = self
        collViewVideos.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        collViewVideos.reloadData()
//        let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
//        cells.forEach { videoCell in
//
//            if videoCell.isPlaying {
//                videoCell.startPlaying()
//            }
//        }
    }
    func showToast(iconName : String) {

        let view = UIView(frame: CGRect(x: self.view.frame.size.width/2 - 80, y: self.view.frame.size.height/2 - 80, width: 160, height: 160))
        var toastIcon = UIImageView(frame: CGRect(x: iconName == "close" ? self.view.frame.size.width/2 - 40 : self.view.frame.size.width/2 - 60, y: iconName == "close" ? self.view.frame.size.height/2 - 40 : self.view.frame.size.height/2 - 60, width: iconName == "close" ? 80 : 120, height: iconName == "close" ? 80 : 120))
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: iconName, withExtension: "gif")!)
//        let advTimeGif = UIImage.sd_animatedGIF(with: imageData)
//         toastIcon = UIImageView(image: advTimeGif)
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: iconName, withExtension: "gif")!)
//        toastIcon.image = UIImage.gifImageWithData(imageData!)
//        toastIcon.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.6) // background color with 0.6 ransparency
        view.layer.cornerRadius = view.frame.height / 2 // for rounded image
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        toastIcon.clipsToBounds = true
        let pauseImg = UIImage(named: iconName)
        toastIcon.image = pauseImg
        toastIcon.tintColor = .white
        toastIcon.alpha = 1.0
        self.view.addSubview(view)
        self.view.addSubview(toastIcon)

        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            view.alpha = 0.0
            toastIcon.alpha = 0.0

                }, completion: {(isCompleted) in
                    view.removeFromSuperview()
                    toastIcon.removeFromSuperview()

        })
    }
    func matchOrPassUser(Id: Int,isMatch : Bool,index : Int)
    {
        var params = [:] as [String:Any]
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                params = ["searchId" :searchJobId,"jobId" : Id,"isMatch": isMatch]
            }
            else
            {
                params = ["candidateId" : Id,"isMatch": isMatch]
            }
        }
        ApiManager().postRequest(parameters: params, api: ApiManager.shared.MatchOrPassUser) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    Toast.show(message:error.localizedDescription, controller: self)
                }
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                  var data = (dataJson["data"] as? NSDictionary)
                  DispatchQueue.main.async {
                      self.showToast(iconName: isMatch == true ? "ticknew" : "close")
                      print("deleted" + "\(index)")
//                      Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                          let indexPathMain = IndexPath(item: index, section: 0)
                          let cell = self.collViewVideos!.cellForItem(at: indexPathMain)
                                          UIView.animate(withDuration: 0.5, animations: {
                                              cell?.center.y -= 500 // Move up 500 pixels
                                              cell?.alpha = 0.0 //the cell will come back from top so I set al[ha to 0.0
                                          }, completion: { (_) in
                                              self.collViewVideos.performBatchUpdates({
                                                  self.mainDataArray.remove(at: indexPathMain.item)
                                                  self.collViewVideos.deleteItems(at:[indexPathMain])
                                              }, completion: { [unowned self] (_) in
                                                 if String(describing: data?["isMutualMatch"] as AnyObject) == "1"
                                                  {
                                                     
                                                     DispatchQueue.main.async
                                                     {
                                                         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CongratsVC") as! CongratsVC
                                                         vc.showMatchDelegate = self
                                                         self.present(vc, animated: true)
                                                     }

                                                 }
                                                  self.collViewVideos.reloadItems(at: self.collViewVideos.indexPathsForVisibleItems)

                                              })
                                          })
                      }
                   

                  }

                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                    }

                }
                
            }

            }
        }
    }
    
    @IBAction func btnSearchAct(_ sender: UIButton) {
//        Toast.show(message:"Under Development", controller: self)

        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                print(inputArray)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
                vc.inputArray = inputArray
                vc.industryId = inputArray["industryId"] as? Int ?? 0
                vc.fromHome = true
                vc.searchId = Int(searchJobId)!
                vc.searchDetailDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                print(inputArray)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewJobAndVideoVC") as! AddNewJobAndVideoVC
                vc.fromHome = true
                vc.inputArray = inputArray
                vc.jobId = Int(searchJobId)!
                vc.searchDetailDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            //        videoUrlArray = []
            //        collViewVideos.reloadData()
            let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
            cells.forEach { videoCell in

                if videoCell.isPlaying {
                    videoCell.stopPlaying()
                }
            }
        }

    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobSearchesVC") as! MyJobSearchesVC
                vc.fromHome = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsVC") as! JobsVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
            cells.forEach { videoCell in

                if videoCell.isPlaying {
                    videoCell.stopPlaying()
                }
            }
        }
     //   self.navigationController?.popViewController(animated: true)
    }
    
}

extension HomeScreenVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    // Bare bones implementation
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: need to implement
        
        return mainDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: need to implem,ent
        
        collectionView.register(VideoPlayerCollViewCell.self, forCellWithReuseIdentifier: "VideoPlayerCollViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPlayerCollViewCell", for: indexPath) as! VideoPlayerCollViewCell
            //Video player
       
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        if let url = URL(string: (mainDataArray[indexPath.row]["videoUrl"] as? String ?? ""))
        {
            cell.imgThumb = UIImageView()
            cell.imgThumb.frame = CGRect(x:0,y:0,width:screenSize.width,height:collectionView.frame.height)
            cell.imgThumb.contentMode = .scaleAspectFit
            cell.imgThumb.sd_setImage(with: URL(string: (mainDataArray[indexPath.row]["thumbnailUrl"] as? String ?? "")), placeholderImage: UIImage(named: ""))
            cell.imgThumb.image = cell.imgThumb.image?.resizeImage(1.0, opaque: false)
            cell.activityIndicator = UIActivityIndicatorView(frame:  CGRect(x:0,y:0,width:screenSize.width,height:collectionView.frame.height))
            cell.activityIndicator.style = .large
            cell.activityIndicator.startAnimating()
            let avPlayer = AVPlayer(url: url)
            cell.playerViewAV.player = avPlayer
            cell.playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width ,height:collectionView.frame.height)
            cell.playerViewAV.videoGravity = AVLayerVideoGravity.resizeAspectFill
            let btnLike = UIButton()
            let btnDislike = UIButton()
            let imageLike = UIImageView(image:  UIImage(named: "tick"))
            imageLike.frame = CGRect(x: ((screenSize.width) / 2) - 75, y: collectionView.frame.height - 82.5, width: 35, height: 35)
            imageLike.contentMode = .scaleAspectFill
            let imageDislike = UIImageView(image:  UIImage(named: "cross"))
            imageDislike.frame = CGRect(x: ((screenSize.width) / 2) + 40, y: collectionView.frame.height - 82.5, width: 35, height: 35)
            imageDislike.contentMode = .scaleAspectFill
            btnLike.frame = CGRect(x: ((screenSize.width) / 2) - 97.5, y: collectionView.frame.height - 105, width: 80, height: 80)
            btnLike.backgroundColor = likeButtonBackGroundColor
            btnLike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.frame = CGRect(x: ((screenSize.width) / 2) + 17.5, y: collectionView.frame.height - 105, width: 80, height: 80)
            btnDislike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.backgroundColor = likeButtonBackGroundColor
            btnDislike.setShadowButton()
            btnLike.setShadowButton()
            btnDislike.addTarget(self, action: #selector(dislikeAct), for: .touchUpInside)
            btnLike.addTarget(self, action: #selector(likeAct), for: .touchUpInside)
            let blackView = UIView()
            blackView.frame = CGRect(x: 0, y: 0, width: cell.playerViewAV.frame.width, height: cell.playerViewAV.frame.height)
            blackView.setGradientBackground()
            cell.contentView.layer.addSublayer(cell.playerViewAV)
            cell.addObserverNotification()
//            cell.contentView.layer.addSublayer()
            
            cell.contentView.addSubview(cell.imgThumb)
            cell.contentView.addSubview(cell.activityIndicator)

            cell.contentView.addSubview(blackView)
            cell.contentView.addSubview(btnDislike)
            cell.contentView.addSubview(btnLike)
            cell.contentView.addSubview(imageLike)
            cell.contentView.addSubview(imageDislike)
            btnLike.tag = indexPath.row
            btnDislike.tag = indexPath.row

            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(HomeScreenVC.leftSwiped))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            cell.addGestureRecognizer(swipeLeft)
            swipeLeft.view?.tag = indexPath.row

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(HomeScreenVC.rightSwiped))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            cell.addGestureRecognizer(swipeRight)
            swipeRight.view?.tag = indexPath.row

                 //Setting cell's player
             }
          return cell
    }
   
    @objc func leftSwiped(_ sender : UISwipeGestureRecognizer)
    {
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobDetailVC") as! MyJobDetailVC
                vc.jobId = String(describing: (mainDataArray[sender.view?.tag ?? 0]["jobId"] as AnyObject))
                vc.likeDislikeDelegate = self
                vc.index = sender.view?.tag ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateDetailVC") as! CandidateDetailVC
                vc.candidateId = String(describing: (mainDataArray[sender.view?.tag ?? 0]["candidateId"] as AnyObject))
                vc.likeDislikeDelegate = self
                vc.index = sender.view?.tag ?? 0

                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
        cells.forEach { videoCell in

            if videoCell.isPlaying {
                videoCell.stopPlaying()
            }
        }
    }
    @objc func rightSwiped(_ sender : UISwipeGestureRecognizer)
    {
       // self.navigationController?.popToRootViewController(animated: true)
      //  Toast.show(message:"Right", controller: self)
    }
    @objc func likeAct(_ sender : UIButton)
    {
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            DispatchQueue.main.async {
                if userType == 2
                {

                    self.matchOrPassUser(Id: self.mainDataArray[sender.tag]["jobId"] as? Int ?? -1, isMatch: true,index : sender.tag)
                }
                else
                {

                    self.matchOrPassUser(Id: self.mainDataArray[sender.tag]["candidateId"] as? Int ?? -1, isMatch: true,index : sender.tag)
                }
            }
         
            
        }
    }
    
    @objc func dislikeAct(_ sender : UIButton)
    {
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {

                matchOrPassUser(Id: mainDataArray[sender.tag]["jobId"] as? Int ?? -1, isMatch: false,index : sender.tag)
            }
            else
            {

                matchOrPassUser(Id: mainDataArray[sender.tag]["candidateId"] as? Int ?? -1, isMatch: false,index : sender.tag)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? VideoPlayerCollViewCell)?.startPlaying()

    }
   
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? VideoPlayerCollViewCell)?.stopPlaying()

    }

}

extension HomeScreenVC: UIScrollViewDelegate {

    // TODO: write logic to stop the video before it begins scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
       cells.forEach { videoCell in

           if videoCell.isPlaying {
               videoCell.stopPlaying()
           }
       }
    }


    // TODO: write logic to start the video after it ends scrolling (programmatically)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
        cells.forEach { videoCell in
           // TODO: write logic to start the video after it ends scrolling
           if !videoCell.isPlaying {
               videoCell.startPlaying()
           }
       }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            // Get the total number of items in the collection view
            let numberOfItems = collViewVideos.numberOfItems(inSection: 0)
            
            // Get the index path of the last item in the collection view
            let lastIndex = IndexPath(item: numberOfItems - 1, section: 0)
            
            // Check if the user is trying to scroll down from the last index
            if let layoutAttributes = collViewVideos.layoutAttributesForItem(at: lastIndex) {
                let distanceToEnd = layoutAttributes.frame.maxY - scrollView.contentOffset.y - scrollView.bounds.height
                if distanceToEnd <= 0 && velocity.y > 0 {
                    // The user is trying to scroll down from the last index, so scroll back to the 0 index
                    targetContentOffset.pointee = CGPoint(x: 0, y: 0)
                }
            }
        }
    
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
