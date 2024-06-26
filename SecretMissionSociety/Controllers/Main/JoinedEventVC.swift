//
//  JoinedEventVC.swift
//  SecretMissionSociety
//
//  Created by mac on 27/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage


class JoinedEventCell: UITableViewCell {
    @IBOutlet weak var img_Event: UIImageView!
    @IBOutlet weak var lbl_EventName: UILabel!
    
   
    @IBOutlet weak var lbl_Quantity: UILabel!
    @IBOutlet weak var btn_Upcoming: UIButton!
    @IBOutlet weak var lbl_Addrss: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
}
class JoinedEventVC: UIViewController {
   
    var nearMeEvents:[JSON]! = []

    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Code: UITextField!
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetEvent()
        trans_View.isHidden = true
     //   tableList.estimatedRowHeight = 200
     //   tableList.rowHeight = UITableView.automaticDimension
        
    }

    @IBAction func crosss(_ sender: Any) {
        trans_View.isHidden = true

    }
    
    @IBAction func submit(_ sender: Any) {
        trans_View.isHidden = true
        WebApplyCode()
    }
    @IBAction func useAcode(_ sender: Any) {
        trans_View.isHidden = false
    }
    
    func WebGetEvent() {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_my_event.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                   
//                    eventid == "1" || eventid == "5" || eventid == "8" || eventid == "15" || eventid == "18" || eventid == "19" || eventid == "20" || eventid == "22" || eventid == "34" || eventid == "24" || eventid == "35" || eventid == "36" || eventid == "31"  || eventid == "28" || eventid == "25"
                    
                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue.filter({
                        $0["id"].stringValue == "1" ||
                        $0["id"].stringValue == "5" ||
                        $0["id"].stringValue == "8" ||
                        $0["id"].stringValue == "15" ||
                        $0["id"].stringValue == "18" ||
                        $0["id"].stringValue == "19" ||
                        $0["id"].stringValue == "20" ||
                        $0["id"].stringValue == "22" ||
                        $0["id"].stringValue == "34" ||
                        $0["id"].stringValue == "24" ||
                        $0["id"].stringValue == "35" ||
                        $0["id"].stringValue == "36" ||
                        $0["id"].stringValue == "31" ||
                        $0["id"].stringValue == "28" ||
                        $0["id"].stringValue == "25" ||
                        $0["id"].stringValue == "32" ||
                        $0["id"].stringValue == "30" ||
                        $0["id"].stringValue == "26" || 
                        $0["id"].stringValue == "27" ||
                        $0["id"].stringValue == "33" || 
                        $0["id"].stringValue == "39"
                        && $0["event_status"].stringValue != "END"})
                    
//                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue.filter({$0["type"].stringValue == "puzzle" || $0["type"].stringValue == "crime" || $0["type"].stringValue == "codigo_frida" || $0["type"].stringValue == "zombie" || $0["type"].stringValue == "rescate" || $0["type"].stringValue == "mision_magica" || $0["type"].stringValue == "mystery_city" && $0["event_status"].stringValue != "END"})

                    self.nearMeEvents = nearMeEvents.filter({$0["event_status"].stringValue != "END"})

                    self.tableList.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
    func WebApplyCode() {
    
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   text_Code.text as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_apply_code.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    WebGetEvent()
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


}
extension JoinedEventVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearMeEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JoinedEventCell
        let data = nearMeEvents[indexPath.row]
        cell.img_Event.sd_setImage(with: URL(string: data["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        cell.lbl_EventName.text = data["event_name"].stringValue
        cell.lbl_Date.text = data["event_date"].stringValue
        cell.lbl_Quantity.text = data["amount"].stringValue
        cell.lbl_Addrss.text = data["address"].stringValue

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kappDelegate.dicCurrentEvent = nearMeEvents[indexPath.row]
        kappDelegate.strEventCode = nearMeEvents[indexPath.row]["event_code"].stringValue
        self.tabBarController?.selectedIndex = 2
     //   strEventCode
    }

}
