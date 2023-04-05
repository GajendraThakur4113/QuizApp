//
//  CreateTeamVC.swift
//  SecretMissionSociety
//
//  Created by mac on 28/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage
import MapKit

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

        if kappDelegate.dicCurrentEvent["event_status"].stringValue == "true" {
            text_name.text = kappDelegate.dicCurrentEvent["team_name"].stringValue
            text_name.isEnabled = false
        } else {
            text_name.isEnabled = true

        }
    }

    
    @IBAction func submit(_ sender: Any) {
        
        if text_name.text?.count != 0 && text_Code.text?.count != 0 {
            WebApplyCode()
        } else {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Please enter Team name and code", on: self)

        }
   
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
                        kappDelegate.strEventCode = text_Code.text!
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
