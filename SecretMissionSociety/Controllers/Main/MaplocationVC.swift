//
//  MaplocationVC.swift
//  SecretMissionSociety
//
//  Created by mac on 27/03/23.
//

import UIKit
import MapKit

class MaplocationVC: UIViewController {

    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_Event: UILabel!
    @IBOutlet weak var img_Event: UIImageView!
    @IBOutlet weak var view_Pop: UIView!
    @IBOutlet weak var mapView: MKMapView!
  
    @IBOutlet weak var lbl_quant: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if kappDelegate.dicCurrentEvent != nil {
            img_Event.sd_setImage(with: URL(string: kappDelegate.dicCurrentEvent["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            lbl_Event.text = kappDelegate.dicCurrentEvent["event_name"].stringValue
            lbl_date.text = kappDelegate.dicCurrentEvent["event_date"].stringValue
            lbl_quant.text = kappDelegate.dicCurrentEvent["amount"].stringValue
            lbl_address.text = kappDelegate.dicCurrentEvent["address"].stringValue
            view_Pop.isHidden = false
        } else {
            view_Pop.isHidden = true

        }
        setCurrentLocation()

    }
    
    //MARK:Map
    
    @IBAction func startNow(_ sender: Any) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
        objVC.completion = {
            print("sdsdd")
        }
        objVC.modalPresentationStyle = .overCurrentContext
        objVC.modalTransitionStyle = .crossDissolve
        self.present(objVC, animated: false, completion: nil)
    }
 
    func setCurrentLocation() {
        print(kappDelegate.coordinate2.coordinate)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(23.51366763042601, -102.20122149999999), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)

    }
    func updateMapViewAndAnnotation(_ address: String, _ location_coordinate: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(location_coordinate) {
            self.initMapViewAnnotation()
            let annotation = MKPointAnnotation()
            annotation.title = address
            annotation.coordinate = location_coordinate
            mapView.addAnnotation(annotation)
            
            mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: location_coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        } else {
            alert(alertmessage: "Location Not Found!")
        }
    }
    
    func initMapViewAnnotation() {
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
    }

    
//    func WebApplyCode() {
//        showProgressBar()
//        var paramsDict:[String:AnyObject] = [:]
//        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
//        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
//        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
//
//        print(paramsDict)
//        CommunicationManeger.callPostService(apiUrl: Router.event_start_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
//            
//            DispatchQueue.main.async { [self] in
//                let swiftyJsonVar = JSON(responseData)
//                print(swiftyJsonVar)
//                if(swiftyJsonVar["status"].stringValue == "1") {
//
//                } else {
//                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)
//
//                }
//                self.hideProgressBar()
//            }
//
//        },failureBlock: { (error : Error) in
//            self.hideProgressBar()
//            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
//        })
//    }

}
extension MaplocationVC: MKMapViewDelegate {
    
//    func showAnnotaionOnMap(arrAll:[JSON]) {
//        mapView.removeAnnotations(mapView.annotations)
//        var arrAllAnn:[MKPointAnnotation] =  []
//        //let sourceAnnotation1 = CustomPointAnnotation()
//        let sourcePlacemark = MKPlacemark(coordinate: userLocationAnnotation.coordinate, addressDictionary: nil)
//        userLocationAnnotation.coordinate = sourcePlacemark.coordinate
////        userLocationAnnotation.title = "My Bus"
//        arrAllAnn.append(userLocationAnnotation)
//
//        for dic in arrAll {
//            let dicChilde = dic["childern_details"]
//            var pickupCoordinat:CLLocationCoordinate2D!
//            let pdiLat = dicChilde["pick_lat"].stringValue
//            let pdiLot = dicChilde["pick_lon"].stringValue
//            let drop_lat = dicChilde["drop_lat"].stringValue
//            let drop_lon = dicChilde["drop_lon"].stringValue
//
//            let sourceAnnotation = CustomPointAnnotation()
//
//            if pdiLat != "" &&  pdiLot != "" && self.dic_Profile["trip_type"].stringValue == "Home - School" {
//                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
//                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat, addressDictionary: nil)
//                sourceAnnotation.coordinate = sourcePlacemark.coordinate
//                sourceAnnotation.imageName = "chiled"
//                sourceAnnotation.title = dicChilde["user_name"].stringValue
//            } else if drop_lat != "" &&  drop_lon != "" && self.dic_Profile["trip_type"].stringValue == "School - Home" {
//                pickupCoordinat = CLLocationCoordinate2DMake(Double(drop_lat)!, Double(drop_lon)!)
//                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat, addressDictionary: nil)
//                sourceAnnotation.coordinate = sourcePlacemark.coordinate
//                sourceAnnotation.imageName = "chiled"
//                sourceAnnotation.title = dicChilde["user_name"].stringValue
//            }
//            arrAllAnn.append(sourceAnnotation)
//        }
//
//
//        self.initMapViewAnnotation()
//
//        self.mapView.showAnnotations(arrAllAnn, animated: true )
//
//    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        print("update viewFor annotation")
//
//        guard !(annotation is MKUserLocation) else {
//            return nil
//        }
        
   

//        if annotation is UserLocationAnnotation {
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserLocationAnnotationView") ?? UserLocationAnnotationView(annotation: annotation, reuseIdentifier: "UserLocationAnnotationView")
//            return annotationView
////            annotationView!.image = #imageLiteral(resourceName: "bus1")
////            print("update viewFor UserLocationAnnotationView")
////            return annotationView
//        }
//
//        if !(annotation is CustomPointAnnotation) {
//            return nil
//        }
//
//
//
//        let reuseId = "test"
//
//        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//        if anView == nil {
//            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            anView!.canShowCallout = true
//        }
//        else {
//            anView!.annotation = annotation
//        }
//
//        let cpa = annotation as! CustomPointAnnotation
//
//        anView?.image = UIImage.init(named: cpa.imageName)
//
//        print("update viewFor CustomPointAnnotation")
//
//
//        return anView
//    }
    

}
