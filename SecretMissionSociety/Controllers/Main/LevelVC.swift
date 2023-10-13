//
//  LevelVC.swift
//  SecretMissionSociety
//
//  Created by mac on 13/10/23.
//

import UIKit
import SwiftyJSON
import SDWebImage


class tableCelllevle:UITableViewCell {
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
}
class LevelVC: UIViewController {

    @IBOutlet weak var table_List: UITableView!
    @IBOutlet weak var lbl_Title: UILabel!
   
    var nearMeEvents:[JSON]! = []
    var arr_Leaderbard:[JSON]! = []
    var isIdSelect:String! = ""
    var isIndex:Int! = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
   
      //  WebGetFinishTime()
        WebGetLeverl()
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Choose Difficulty", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }

    
    func WebGetLeverl() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_level.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                  
                    nearMeEvents = swiftyJsonVar["result"].arrayValue
                    table_List.reloadData()

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }


    @IBAction func Next(_ sender: Any) {
  
        if isIndex != -1 {
      
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
            nVC.strDetail = kappDelegate.dicCurrentEvent["disclaimer"].stringValue
            self.navigationController?.pushViewController(nVC, animated: true)

        } else {
            
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Choose difficulty", on: self)

        }
    }
    

}
extension LevelVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return nearMeEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = table_List.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableCelllevle

            let data = nearMeEvents[indexPath.row]

            cell.lbl_Name.text = "\(data["level"].stringValue)"

        if isIndex == indexPath.row {
            cell.imgCheck.image = UIImage.init(named: "checkIn")
        } else {
            cell.imgCheck.image = UIImage.init(named: "uncheckIn")

        }

           return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        isIndex = indexPath.row
        let data = nearMeEvents[indexPath.row]
        kappDelegate.strLevelId = "\(data["id"].stringValue)"
        table_List.reloadData()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 51

    }
}
