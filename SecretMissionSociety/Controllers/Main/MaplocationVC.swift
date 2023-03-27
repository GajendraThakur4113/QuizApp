//
//  MaplocationVC.swift
//  SecretMissionSociety
//
//  Created by mac on 27/03/23.
//

import UIKit
import MapKit

class MaplocationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        var mapRegion = MKCoordinateRegion()

        mapRegion.center = CLLocationCoordinate2DMake(23.51366763042601, -102.20122149999999)
        mapRegion.span.latitudeDelta = 80
        mapRegion.span.longitudeDelta = 360
        mapView.setRegion(mapRegion, animated: true)

        // Do any additional setup after loading the view.
    }
    


}
