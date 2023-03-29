//
//  InstructionVC.swift
//  SecretMissionSociety
//
//  Created by mac on 29/03/23.
//

import UIKit

class InstructionVC: UIViewController {
 
    @IBOutlet weak var text_Detail: UITextView!
    var strDetail:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Instructions", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        self.text_Detail.attributedText = strDetail.htmlToAttributedString

    }


    @IBAction func next(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
 

}
