//
//  FlgMaViewVC.swift
//  SecretMissionSociety
//
//  Created by mac on 29/03/23.
//

import UIKit
import MapKit
import SwiftyJSON

class FlgMaViewVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
   
    var arrlist:[JSON]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Map", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        WebGetCode()
    }
    
    //MARK:Map
     
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

    
    func WebGetCode() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_instructions_game.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrlist = swiftyJsonVar["result"].arrayValue
                    showAnnotaionOnMap(arrAll: arrlist)
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
extension FlgMaViewVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
          
            let strId = view.annotation?.title ?? ""
            print("didSelectAnnotationTapped \(view.annotation?.title ?? "")")
            let arr = arrlist.filter({$0["id"].stringValue == strId})
            print("didSelectAnnotationTapped \(arr)")
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
            nVC.dicCurrentQuestion = arr[0]
            self.navigationController?.pushViewController(nVC, animated: true)

        }

    func showAnnotaionOnMap(arrAll:[JSON]) {
        mapView.removeAnnotations(mapView.annotations)
        var arrAllAnn:[MKPointAnnotation] =  []

        for dic in arrAll {
            
            var pickupCoordinat:CLLocationCoordinate2D!
            let pdiLat = dic["lat"].stringValue.trimmingCharacters(in: .whitespaces)
            let pdiLot = dic["lon"].stringValue.trimmingCharacters(in: .whitespaces)

            print("All latlong \(pdiLat) \(pdiLot)")
            print("All latlong \(Double(pdiLat) ?? 0.0) \(Double(pdiLot))")

            let sourceAnnotation = CustomPointAnnotation()

            if pdiLat != "" &&  pdiLot != "" && dic["answer_status"].numberValue == 0 {
                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat!, addressDictionary: nil)
                sourceAnnotation.coordinate = sourcePlacemark.coordinate
                sourceAnnotation.imageName = "flag_red"
                sourceAnnotation.title = dic["id"].stringValue
            
            } else if pdiLat != "" &&  pdiLot != "" && dic["answer_status"].numberValue == 1 {
                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat!, addressDictionary: nil)
                sourceAnnotation.coordinate = sourcePlacemark.coordinate
                sourceAnnotation.imageName = "flag_green"
                sourceAnnotation.title = dic["id"].stringValue

            }
            arrAllAnn.append(sourceAnnotation)
        }


        self.initMapViewAnnotation()

        self.mapView.showAnnotations(arrAllAnn, animated: true )

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        
        anView?.image = UIImage.init(named: cpa.imageName)
      //  anView?.ti = cpa
        
        return anView
    }
    

}
