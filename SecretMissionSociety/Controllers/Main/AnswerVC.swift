//
//  AnswerVC.swift
//  SecretMissionSociety
//
//  Created by mac on 30/03/23.
//

import UIKit
import MapKit
import SwiftyJSON
import SDWebImage

class AnswerVC: UIViewController {
    
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
  
    @IBOutlet weak var table_Answer: UITableView!
    var dicCurrentQuestion:JSON!
    var arroption:[String] = []
    var isIndex:Int! = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
      
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: dicCurrentQuestion["event_type"].stringValue, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
  
        transView.isHidden = true
    
        text_Detail.attributedText = "\(dicCurrentQuestion["hint_discovered"].stringValue)  \n\n \(dicCurrentQuestion["hint_discovered_sp"].stringValue)".htmlToAttributedString
        img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        arroption.append(dicCurrentQuestion["option_A"].stringValue)
        arroption.append(dicCurrentQuestion["option_B"].stringValue)
        arroption.append(dicCurrentQuestion["option_C"].stringValue)
        arroption.append(dicCurrentQuestion["option_D"].stringValue)

    }

    @IBAction func cross(_ sender: Any) {
        transView.isHidden = true
    }
    override func rightClick() {

    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        transView.isHidden = true

    }
    @IBAction func hintt(_ sender: Any) {
    }
    @IBAction func answer(_ sender: Any) {
        transView.isHidden = false

    }
}
extension AnswerVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arroption.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_Answer.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
       
        cell.lbl_lang.text = arroption[indexPath.row]
        
        if indexPath.row == isIndex {
            cell.img_Tr.image = UIImage.init(named: "checkIn")
        } else {
            cell.img_Tr.image = UIImage.init(named: "uncheckIn")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isIndex = indexPath.row
        table_Answer.reloadData()
    }

}
