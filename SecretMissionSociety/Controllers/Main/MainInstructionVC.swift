//
//  MainInstructionVC.swift
//  SecretMissionSociety
//
//  Created by mac on 29/03/23.
//

import UIKit
import MapKit
import SwiftyJSON

class MainInstructionVC: UIViewController {
  
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Instructions", CenterImage: "", RightTitle: "", RightImage: "Dotss", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        transView.isHidden = true
        text_Detail.attributedText = "Haz Click en el menú de arriba. \n  Click en Mapa para ver ubicaciones.\n  Click en Inventario para ver pistas encontradas \n * Click en Rompecabezas final para lograr terminar el reto".htmlToAttributedString
    }

    @IBAction func cross(_ sender: Any) {
        transView.isHidden = true
    }
    override func rightClick() {
        transView.isHidden = false

    }
    @IBAction func instruction(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
        nVC.strDetail = kappDelegate.dicCurrentEvent["event_instructions"].stringValue
        self.navigationController?.pushViewController(nVC, animated: true)
    }
    @IBAction func map(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FlgMaViewVC") as! FlgMaViewVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    @IBAction func inventery(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InventorylistVC") as! InventorylistVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    @IBAction func finalPuzzle(_ sender: Any) {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleVC") as! FinalPuzzleVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
}
