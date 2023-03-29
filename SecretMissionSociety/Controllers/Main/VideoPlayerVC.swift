//
//  VideoPlayerVC.swift
//  SecretMissionSociety
//
//  Created by mac on 29/03/23.
//

import UIKit
import AVKit

class VideoPlayerVC: UIViewController {
    
    
    @IBOutlet weak var view_Video: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
     
        print("\(kappDelegate.dicCurrentEvent["video"].stringValue)")
      

        if let url = URL(string: kappDelegate.dicCurrentEvent["video"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {

            print("sdsd \(url)")

                  let player = AVPlayer(url: url)
                  let controller = AVPlayerViewController()
                  controller.player = player
                  controller.view.frame = self.view_Video.frame
                  self.view_Video.addSubview(controller.view)
                  self.addChild(controller)
                  player.play()
            
            
//            let videoAsset = AVAsset(url: url)
//            // Create an AVPlayerItem with asset
//            let videoPlayerItem = AVPlayerItem(asset: videoAsset)
//            // Initialize player with the AVPlayerItem instance.
//            let player = AVPlayer(playerItem: videoPlayerItem)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.view_Video.bounds
//            self.view_Video.layer.addSublayer(playerLayer)
//            player.play()

              }

    }


    @IBAction func next(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "MainInstructionVC") as! MainInstructionVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
 

}
