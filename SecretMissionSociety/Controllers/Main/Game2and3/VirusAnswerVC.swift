//
//  VirusAnswerVC.swift
//  SecretMissionSociety
//
//  Created by mac on 06/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class VirusAnswerVC: UIViewController {
    
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var text_Answer: UITextField!
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    
    var arrAllQuestion:[JSON]! = []
    var isCurrentQuestion:Int! = 0
    var dicCurrentQuestion:JSON!

    var totalSecond = Int()
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetVirusQues()
        transView.isHidden = true
        
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()

    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int

//        if totalSecond == 0 {
//            timer?.invalidate()
//        }
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        lbl_Timer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    @IBAction func no(_ sender: Any) {
        transView.isHidden = true
    }
    @IBAction func yes(_ sender: Any) {
        transView.isHidden = true
        WebAddPenality()
    }
    @IBAction func SubmitAnswer(_ sender: Any) {
        if text_Answer.text?.count != 0 {
            WebFinalAnswerGame()
        } else {
            print("Enter Answer")
        }
    }
    @IBAction func GiveUp(_ sender: Any) {
        transView.isHidden = false
    }
    @IBAction func Hint(_ sender: Any) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HIntAnswerVC") as! HIntAnswerVC
        objVC.completion = {
        }
        objVC.arroption = ["Show Hint1 (2 minutes penalty)","Show Hint2 (5 minutes penalty)"]
        objVC.dicCurrentQuestion =  dicCurrentQuestion
        objVC.strFrom =  "virus"
        objVC.modalPresentationStyle = .overCurrentContext
        objVC.modalTransitionStyle = .crossDissolve
        self.present(objVC, animated: false, completion: nil)
    }

    func changeQuestion()  {
        isCurrentQuestion += 1
        dicCurrentQuestion = arrAllQuestion[isCurrentQuestion]
        img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        text_Detail.attributedText = dicCurrentQuestion["instructions\(Singleton.shared.languagePar!)"].stringValue.htmlToAttributedString
        text_Answer.text = ""

    }
    func WebAddPenality() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["time"]     =   "10" as AnyObject
        paramsDict["hint_type"]     =   "3" as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_virus_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    text_Answer.text = dicCurrentQuestion["option_Ans"].stringValue
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

    func WebGetVirusQues() {
       
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   "4" as AnyObject

        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_virus_event_answer_new.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrAllQuestion = swiftyJsonVar["result"].arrayValue
                    dicCurrentQuestion = arrAllQuestion[isCurrentQuestion]
                    img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
                    text_Detail.attributedText = dicCurrentQuestion["instructions\(Singleton.shared.languagePar!)"].stringValue.htmlToAttributedString

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func WebFinalAnswerGame() {
    
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   kappDelegate.strEventCode as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject
        paramsDict["event_game_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["ans"]     =   text_Answer.text! as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_virus_event_ans.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    changeQuestion()
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
