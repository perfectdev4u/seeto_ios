//
//  HomeScreenVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit
import AVFoundation

class HomeScreenVC: UIViewController {
    
    @IBOutlet var collViewVideos: UICollectionView!
    let screenSize: CGRect = UIScreen.main.bounds

    var videoUrlArray = ["http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v","http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v","http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"]
   // var videoUrlArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collViewVideos.layer.cornerRadius = 40
        collViewVideos.delegate = self
        collViewVideos.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let cells = collViewVideos.visibleCells.compactMap({ $0 as? VideoPlayerCollViewCell })
        cells.forEach { videoCell in

            if videoCell.isPlaying {
                videoCell.stopPlaying()
            }
        }
    }
    
    @IBAction func btnSearchAct(_ sender: UIButton) {
//        Toast.show(message:"Under Development", controller: self)

        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsVC") as! JobsVC
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
        
        return videoUrlArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: need to implem,ent
        
        collectionView.register(VideoPlayerCollViewCell.self, forCellWithReuseIdentifier: "VideoPlayerCollViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPlayerCollViewCell", for: indexPath) as! VideoPlayerCollViewCell
            //Video player
        if let url = URL(string: videoUrlArray[indexPath.row])
        {
            let avPlayer = AVPlayer(url: url)
            cell.playerViewAV.player = avPlayer
            cell.playerViewAV.frame = CGRect(x:0,y:0,width:screenSize.width - 20,height:collectionView.frame.height)
            cell.playerViewAV.videoGravity = AVLayerVideoGravity.resize
            let btnLike = UIButton()
            let btnDislike = UIButton()
            let imageLike = UIImageView(image:  UIImage(named: "tick"))
            imageLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 75, y: collectionView.frame.height - 82.5, width: 35, height: 35)
            imageLike.contentMode = .scaleAspectFill
            let imageDislike = UIImageView(image:  UIImage(named: "cross"))
            imageDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 40, y: collectionView.frame.height - 82.5, width: 35, height: 35)
            imageDislike.contentMode = .scaleAspectFill
            btnLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 97.5, y: collectionView.frame.height - 105, width: 80, height: 80)
            btnLike.backgroundColor = likeButtonBackGroundColor
            btnLike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 17.5, y: collectionView.frame.height - 105, width: 80, height: 80)
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
            cell.contentView.addSubview(blackView)
            cell.contentView.addSubview(btnDislike)
            cell.contentView.addSubview(btnLike)
            cell.contentView.addSubview(imageLike)
            cell.contentView.addSubview(imageDislike)
                 //Setting cell's player
             }
          return cell
    }
 
    @objc func likeAct(_ sender : UIButton)
    {
        Toast.show(message:"Done", controller: self)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectResumeVC") as! SelectResumeVC
//        self.present(vc, animated: true)
    }
    
    @objc func dislikeAct(_ sender : UIButton)
    {
        Toast.show(message:"Done", controller: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenSize.width - 20, height: collectionView.frame.height)
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
}
