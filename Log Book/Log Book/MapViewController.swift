//
//  MapViewController.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 08.06.2021.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var geoDataArray : [GeoData] = []
    @IBOutlet weak var MapView: MKMapView!
    
    @IBAction func ReloadMapButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if geoDataArray.count > 0 {
            //map center location
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: geoDataArray[0].latitude, longitude:geoDataArray[0].longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            MapView.setRegion(region, animated: true)

            //point draw
            //let point = MKMapPoint(CLLocationCoordinate2D(latitude: geoDataArray[0].latitude, longitude: geoDataArray[0].longitude))
            for pt in geoDataArray {
                let annotation = MKPointAnnotation()  // <-- new instance here
                annotation.coordinate = CLLocationCoordinate2D(latitude: pt.latitude, longitude: pt.longitude)
                annotation.title = "Point"
                MapView.addAnnotation(annotation)
            }
        }
                
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "logBook" {
//            if let nextViewController = segue.destination as? LogViewController {
//                nextViewController.geoDataArray = geoDataArray
//
//            }
//        }
//
//    }
    
}
