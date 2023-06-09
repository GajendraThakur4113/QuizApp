//
//  MapBottomBarVC.swift
//  SecretMissionSociety
//
//  Created by mac on 27/06/23.
//

import UIKit
import MapKit
import SwiftyJSON

class MapBottomBarVC: UIViewController {
    
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var view_Bottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
   
    var arrlist:[JSON]! = []
    
    var totalSecond = Int()
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

       // WebGetCode()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetCode()
    }
    override func viewDidAppear(_ animated: Bool) {
        WebGetTime()
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

        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        lbl_Time.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)

    }
    @IBAction func backk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func Archived(_ sender: UIButton) {

        if sender.tag == 0 {
          
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InventorylistVC") as! InventorylistVC
             self.navigationController?.pushViewController(nVC, animated: true)

        } else if sender.tag == 1 {
           
            if kappDelegate.dicCurrentEvent["id"].stringValue == "8" {
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleCodigoVc") as! FinalPuzzleCodigoVc
                self.navigationController?.pushViewController(nVC, animated: true)

            } else {
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleVC") as! FinalPuzzleVC
                self.navigationController?.pushViewController(nVC, animated: true)

            }

        } else if sender.tag == 2 {
         
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FlgMaViewVC") as! FlgMaViewVC
            self.navigationController?.pushViewController(nVC, animated: true)

        } else if sender.tag == 3 {
            
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
            nVC.strDetail = kappDelegate.dicCurrentEvent["event_instructions"].stringValue
            nVC.strfrom = "map"
            self.navigationController?.pushViewController(nVC, animated: true)

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

    
    func WebGetTime() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {

                    let sec = Int(truncating: swiftyJsonVar["result"].numberValue).msToSeconds
                    print("secsec \(sec)")
                    totalSecond = Int(sec)
                    print("secsec \(totalSecond)")

                    startTimer()
                    
                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
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

extension MapBottomBarVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
//                if kappDelegate.dicCurrentEvent["type"].stringValue != "crime" {
                    
                    let strId = view.annotation?.title ?? ""
                    print("didSelectAnnotationTapped \(view.annotation?.title ?? "")")
                    let arr = arrlist.filter({$0["id"].stringValue == strId})
                    print("didSelectAnnotationTapped \(arr)")
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                    nVC.dicCurrentQuestion = arr[0]
                    kappDelegate.strIsFrom = "No"
                    self.navigationController?.pushViewController(nVC, animated: true)

        
//                }

        }

    func showAnnotaionOnMap(arrAll:[JSON]) {
        mapView.removeAnnotations(mapView.annotations)
        var arrAllAnn:[MKPointAnnotation] =  []
        var coordinates:[CLLocationCoordinate2D] =  []
      

        var isCurrentId:Double! = 0.0
       
        if kappDelegate.strIsFrom == "Yes" {
            
            let pdiLat = kappDelegate.dicCurrentQuestion["lat"].stringValue.trimmingCharacters(in: .whitespaces)
            let pdiLot = kappDelegate.dicCurrentQuestion["lon"].stringValue.trimmingCharacters(in: .whitespaces)
            isCurrentId = Double(kappDelegate.dicCurrentQuestion["id"].stringValue.trimmingCharacters(in: .whitespaces))! + 1.0
            coordinates.append(CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!))

        }
        for dic in arrAll {
            
            var pickupCoordinat:CLLocationCoordinate2D!
            let pdiLat = dic["lat"].stringValue.trimmingCharacters(in: .whitespaces)
            let pdiLot = dic["lon"].stringValue.trimmingCharacters(in: .whitespaces)
            let idISCurent = dic["id"].stringValue.trimmingCharacters(in: .whitespaces)

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
            print("No Routesfs \(isCurrentId)")
            print("No Routefssf \(Double(idISCurent)!)")

            if kappDelegate.strIsFrom == "Yes"  {
                print("Yes Route ")

                if isCurrentId == Double(idISCurent)! {
                    coordinates.append(CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!))
                    
                    let sourcePlacemark = MKPlacemark(coordinate: coordinates[0], addressDictionary: nil)
                    let destinationPlacemark = MKPlacemark(coordinate: coordinates[1], addressDictionary: nil)
                    
                    

                    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

                    // Calculate the direction
                    
                    let directionRequest = MKDirections.Request()
                    directionRequest.source = sourceMapItem
                    directionRequest.destination = destinationMapItem
                    directionRequest.transportType = .automobile

                    let directions = MKDirections(request: directionRequest)
                    
                    directions.calculate {
                        (response, error) -> Void in
                        
                        guard let response = response else {
                            if let error = error {
                                print("Error: \(error)")
                            }
                            
                            return
                        }
                        
                        let route = response.routes[0]
                        self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        //            let rect = route.polyline.boundingMapRect
                        //            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                        
                        let mapRect = MKPolygon(points: route.polyline.points(), count: route.polyline.pointCount)
                        self.mapView.setVisibleMapRect(mapRect.boundingMapRect, edgePadding: UIEdgeInsets(top: 150.0,left: 50.0,bottom: 150.0,right: 50.0), animated: true)
                        
                        print("Yes Route dsdsd")

                    }
                }
            } else {
                
                print("No Route")
                
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //        if let overlay = overlay as? MKPolyline {
        /// define a list of colors you want in your gradient
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = hexStringToUIColor(hex: MAIN_COLOR)
            renderer.lineWidth = 7
            return renderer
        }
        
        return MKOverlayRenderer()
        
        //        let gradientColors = [ hexStringToUIColor(hex: MAIN_COLOR), hexStringToUIColor(hex: MAIN_COLOR)]
        //
        //        /// Initialise a GradientPathRenderer with the colors
        //        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        //
        //        /// set a linewidth
        //        polylineRenderer.lineWidth = 7
        //        return polylineRenderer
        //        }
    }

}

extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
}
extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
