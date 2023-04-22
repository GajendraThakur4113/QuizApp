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
import WebKit

class AnswerVC: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var height_table: NSLayoutConstraint!
    @IBOutlet weak var img_Answer: UIImageView!
    @IBOutlet weak var view_QuizSolved: UIView!
    @IBOutlet weak var view_Question: UIView!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
  
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var table_Answer: UITableView!
    var dicCurrentQuestion:JSON!
    var arroption:[String] = []
    var isIndex:Int! = -1
    var arroptionAdnswer:[String] = ["A","B","C","D"]
    var isAnswer:String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
      
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: dicCurrentQuestion["event_type"].stringValue, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
  
        transView.isHidden = true
    
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        webView.navigationDelegate = self
        webView.loadHTMLString(Singleton.shared.header + "\(dicCurrentQuestion["instructions"].stringValue)" + "</body>", baseURL: nil)
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        webView.isHidden = false

        table_Answer.estimatedRowHeight = 65
        table_Answer.rowHeight = UITableView.automaticDimension

//        text_Detail.attributedText = "\(dicCurrentQuestion["hint_discovered"].stringValue) \n\n \(dicCurrentQuestion["hint_discovered_sp"].stringValue)".htmlToAttributedString
        img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        arroption.append(dicCurrentQuestion["option_A"].stringValue)
        arroption.append(dicCurrentQuestion["option_B"].stringValue)
        arroption.append(dicCurrentQuestion["option_C"].stringValue)
        arroption.append(dicCurrentQuestion["option_D"].stringValue)
        table_Answer.reloadData()
    }

    @IBAction func cross(_ sender: Any) {
        transView.isHidden = true
    }
    
    @IBAction func gotoMap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        
        if isIndex != -1 {
            WebAddAnswer()
        } else {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Choose option", on: self)

        }
    }
    @IBAction func hintt(_ sender: Any) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HIntAnswerVC") as! HIntAnswerVC
        objVC.completion = {
        }
        objVC.arroption = ["Show Hint1 (2 minutes penalty)","Show Hint2 (5 minutes penalty)","Show Hint3 (10 minutes penalty)"]
        objVC.dicCurrentQuestion =  dicCurrentQuestion
        objVC.modalPresentationStyle = .overCurrentContext
        objVC.modalTransitionStyle = .crossDissolve
        self.present(objVC, animated: false, completion: nil)

    }
    @IBAction func answer(_ sender: Any) {
        transView.isHidden = false
        view_QuizSolved.isHidden = true
        view_Question.isHidden = false

    }
    
    //MARK:API
    func WebAddAnswer() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_game_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_instructions_game_ans.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    transView.isHidden = false
                    view_QuizSolved.isHidden = false
                    view_Question.isHidden = true
                    img_Answer.sd_setImage(with: URL(string: dicCurrentQuestion["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Wrong Answer 2 Min Time Penalty Added", on: self)
                    WebAddPenality()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebAddPenality() {

        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject
        paramsDict["time"]     =   "2" as AnyObject
        paramsDict["hint_type"]     =   "2" as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
}

extension AnswerVC: UITableViewDelegate,UITableViewDataSource {
    
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
        isAnswer = arroptionAdnswer[indexPath.row]
        table_Answer.reloadData()
    }

}
