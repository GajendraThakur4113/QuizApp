//
//  PuzzleInstructionVC.swift
//  SecretMissionSociety
//
//  Created by mac on 24/05/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class PuzzleInstructionVC: UIViewController {
    
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Welcome", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        img_user.sd_setImage(with: URL(string: "http://appsmsjuegos.com/Quiz/uploads/images/" + kappDelegate.dicCurrentEvent["intro_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

        text_Detail.text = kappDelegate.dicCurrentEvent["intro_sp"].stringValue
    }

    @IBAction func cross(_ sender: Any) {

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    
}
