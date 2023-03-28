//
//  CreateTeamVC.swift
//  SecretMissionSociety
//
//  Created by mac on 28/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CreateTeamVC: UIViewController {
    
    var nearMeEvents:[JSON]! = []

    @IBOutlet weak var text_name: UITextField!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Code: UITextField!
    
    var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
     //   tableList.estimatedRowHeight = 200
     //   tableList.rowHeight = UITableView.automaticDimension
        
    }

    
    @IBAction func submit(_ sender: Any) {
        WebApplyCode()
    }
    @IBAction func useAcode(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func WebApplyCode() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =   text_Code.text! as AnyObject
        paramsDict["team_name"]     =   text_name.text! as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_start_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    if let completion = completion {
                      completion()
                    }
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.dismiss(animated: false, completion: nil)
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }


}
