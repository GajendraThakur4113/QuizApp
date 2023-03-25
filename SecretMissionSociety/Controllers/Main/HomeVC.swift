//
//  HomeVC.swift
//  SecretMissionSociety
//
//  Created by mac on 25/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class HomeVC: UIViewController {
    
    @IBOutlet weak var bannerCollecView: UICollectionView!
    @IBOutlet weak var nearestCollecView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //Mark:- Properties
    var indexPath = 0
    var timer:Timer?
    var counter = 0
    var bannerResult:[JSON]! = []
    var nearMeEvents:[JSON]! = []


    override func viewDidLoad() {
        super.viewDidLoad()
        WebGetCategory()
        pageControlCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //Mark:- Functions
    func pageControlCall(){
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //Mark:- Button Actions
    @IBAction func backBannerBtn(_ sender: UIButton){
        if counter > self.bannerResult.count{
            //Singleton.shared.showToast(text: "")
        }else{
            counter = counter - 1
            pageControl.currentPage = counter
            bannerCollecView.scrollToItem(at: IndexPath(item: counter, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
   
    @IBAction func frontBannerBtn(_ sender: UIButton){
        if counter <= 0{
            counter = 0
        }
        counter = counter + 1
        if counter >= self.bannerResult.count{
         //   Singleton.shared.showToast(text: "")
        }else{
            pageControl.currentPage = counter
            bannerCollecView.scrollToItem(at: IndexPath(item: counter, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        
    }
    //MARK: API
    func WebGetCategory() {
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_banner.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.bannerResult = swiftyJsonVar["result"].arrayValue
                    self.bannerCollecView.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    
  
}



extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollecView{
            return self.bannerResult.count
        } else {
            return nearMeEvents.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollecView{
            print("Banner")
            let cell = bannerCollecView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            let data = self.bannerResult[indexPath.row]
            cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setIndicatorStyle(.gray)
            cell.imgView.sd_setImage(with: URL(string: data["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            return cell
        } else {
            print("Nearestsddsd")
            let cell = nearestCollecView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionCell", for: indexPath) as! NearestCollectionCell
            let data = nearMeEvents[indexPath.row]
//            cell.img.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
//            cell.lblTitle.text = decode("\(data.restaurant_name ?? "")")
//            cell.lblTime.text = "\(data.address ?? "")"

            return cell
        }
        
    }
  

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == nearestCollecView{
//            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
//            nVC.nearestRest = self.nearestRest[indexPath.row]
//            nVC.screenType = "Rest"
//            self.navigationController?.pushViewController(nVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollecView{
            return CGSize(width: self.bannerCollecView.frame.width, height: self.bannerCollecView.frame.height)
        } else if collectionView == nearestCollecView {
            return CGSize(width: self.nearestCollecView.frame.width/2.3, height: self.nearestCollecView.frame.height)
        }  else{
            return CGSize()
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.counter = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}


//Mark:- Collection Cell Class
class BannerCollectionCell: UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
}

class NearestCollectionCell: UICollectionViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

