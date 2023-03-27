//
//  AccountlistVC.swift
//  SecretMissionSociety
//
//  Created by mac on 27/03/23.
//

import UIKit

class AccountlistVC: UIViewController {
    
    //Mark:- IBOutelts
    @IBOutlet weak var tblView: UITableView!
    
    var arrLangu = ["Edit Details","Change Password","Play a Game","Visit Website","Privacy Policy","Contact Us","Change Language"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "", CenterTitle: "Profile", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: BLACK_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }

    @IBAction func langua(_ sender: UIButton) {
      

    }

}

extension AccountlistVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLangu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
        cell.lbl_lang.text = arrLangu[indexPath.row]
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
