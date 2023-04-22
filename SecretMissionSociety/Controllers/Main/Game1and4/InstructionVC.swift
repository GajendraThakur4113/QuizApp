//
//  InstructionVC.swift
//  SecretMissionSociety
//
//  Created by mac on 29/03/23.
//

import UIKit
import WebKit

class InstructionVC: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
 
    @IBOutlet weak var webView: WKWebView!
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
        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        webView.navigationDelegate = self
        webView.loadHTMLString(Singleton.shared.header + strDetail + "</body>", baseURL: nil)
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        webView.isHidden = false
        text_Detail.isHidden = true
        
        
        self.tabBarController?.tabBar.isHidden = true
    }


    @IBAction func next(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        self.navigationController?.pushViewController(nVC, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        print("sdsdsd")
    }


}
