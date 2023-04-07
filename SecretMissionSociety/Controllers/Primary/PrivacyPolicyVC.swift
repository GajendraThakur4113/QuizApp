//
//  PrivacyPolicyVC.swift
//  VIBRAS
//
//  Created by mac on 20/06/22.
//

import UIKit
import SwiftyJSON

class PrivacyPolicyVC: UIViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    
    //Mark:- Properties
    var screenType:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtDetails.text = ""
        if self.screenType == "A" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.AboutUs
        } else if self.screenType == "P" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.privac
        } else if self.screenType == "T" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.terms
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    //Mark:- Functions
    func getAboutUsAPI(strAPI:String){
     
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["language"]     =   Singleton.shared.language as AnyObject
    
        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    self.txtDetails.attributedText = swiftyJsonVar["result"]["description"].stringValue.htmlToAttributedString
                } else {
                    let message = swiftyJsonVar["result"].string
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message!, on: self)
                }
                self.hideProgressBar()
            }
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
        
        //Mark:- Button Actions
    @IBAction func backBtnClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)

    }


}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        
        return htmlToAttributedString?.string ?? ""
    }
}
extension NSAttributedString {

    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }

}
