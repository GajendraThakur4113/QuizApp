//
//  WelcomeVC.swift
//  SecretMissionSociety
//
//  Created by mac on 06/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Welcome to Virus", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        img_user.sd_setImage(with: URL(string: kappDelegate.dicCurrentVirus["description_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

        text_Detail.text = kappDelegate.dicCurrentVirus["description\(Singleton.shared.languagePar!)"].stringValue
    }

    @IBAction func cross(_ sender: Any) {

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        nVC.strFrom = "virus"
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    
}
