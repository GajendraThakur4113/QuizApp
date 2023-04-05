//
//  VirsuHomeVC.swift
//  SecretMissionSociety
//
//  Created by mac on 05/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class VirsuHomeVC: UIViewController {
    
    var nearMeEvents:[JSON]! = []

    @IBOutlet weak var img_Virus: UIImageView!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetEvent()
        trans_View.isHidden = true
        
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
