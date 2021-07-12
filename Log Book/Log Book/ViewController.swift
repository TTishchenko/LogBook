//
//  ViewController.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 08.06.2021.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var GeoDataNow: UIView!
    @IBOutlet weak var TableWithGeoData: UITableView!
    
    @IBOutlet weak var Latitude: UILabel!
    @IBOutlet weak var Longitude: UILabel!
    @IBOutlet weak var Course: UILabel!
    @IBOutlet weak var Speed: UILabel!
    @IBOutlet weak var Adress: UILabel!
    @IBOutlet weak var Frequency: UILabel!
    
    var geoDataArray : [GeoData] = []
    var manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //регистрируется изменение позиции только при превышении дистанции
        manager.distanceFilter = 200
        
        //kCLLocationAccuracyBest
        
        //manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        //TableWithGeoData.reloadData()
    }

    @IBAction func FreqStepper(_ sender: UIStepper) {
        Frequency.text = String(sender.value)
        let mString = Frequency.text
        let mDouble = Double(mString!)
        manager.distanceFilter = mDouble!
    }
    
    @IBAction func StartButton(_ sender: Any) {
        manager.startUpdatingLocation()
    }
    @IBAction func StopButton(_ sender: Any) {
        manager.stopUpdatingLocation()
        
        //working with CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for point in geoDataArray {

            let newpoint = NavigationData(context: context)
            newpoint.dt = point.dt
            newpoint.latitude = Float(point.latitude)
            newpoint.longitude = Float(point.longitude)
            newpoint.speed = Float(point.speed)
            newpoint.course = Float(point.course)
            newpoint.address = point.address
            
            do {
                try context.save()
                print ("saved...")
            } catch {
                print("eror")
            }
        }
    }
    @IBAction func ResetButton(_ sender: Any) {
        geoDataArray = []
        manager.stopUpdatingLocation()
        TableWithGeoData.reloadData()
        
        //delete all from coredata
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NavigationData")
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "name = %@", "Saphira")
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "address") as? String {
                        print("an item " + name)
                    }
                    
                    //delete --begin
                    context.delete(result)

                    //delete --end
                }
                do {
                    try context.save()
                } catch {
                    print("delelte DB error")
                }
            } else {
                print ("no results")
            }
            
        } catch {
            print("error")
        }
    }
    @IBAction func MapButton(_ sender: Any) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        self.Latitude.text = String(location.coordinate.latitude)
        self.Longitude.text = String(location.coordinate.longitude)
        self.Course.text = String(location.course)
        self.Speed.text = String(location.speed)
        
        var address = ""
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                print(error ?? "error")
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    //
//                    if placemark.subThoroughfare != nil {
//                        address += placemark.subThoroughfare! + " "
//                    }
                    
                    //street
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + "\n"
                    }
                    
                    if placemark.subLocality != nil {
                        address += placemark.subLocality! + "\n"
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        address += placemark.subAdministrativeArea! + "\n"
                    }
                    
                    //postal code
//                    if placemark.postalCode != nil {
//                        address += placemark.postalCode! + "\n"
//                    }
                    
                    //country
                    if placemark.country != nil {
                        address += placemark.country! + "\n"
                    }
                    
                    self.Adress.text = address
                }
            }
            
            //self.GeoLable.text = String(location.coordinate.latitude)+" "+String(location.coordinate.longitude)+" "+String(location.course)+" "+String(location.speed)+" "+address
            
            self.geoDataArray.insert(GeoData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, course: location.course, speed: location.speed, address: address, dt: NSDate() as Date), at: 0)
            self.TableWithGeoData.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let nextViewController = segue.destination as? MapViewController {
                nextViewController.geoDataArray = geoDataArray
                
            }
        }
        
        if segue.identifier == "logBook1" {
            if let nextViewController = segue.destination as? LogViewController {
                nextViewController.geoDataArray = geoDataArray

            }
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoDataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let georow : GeoData = geoDataArray[indexPath.row]
        cell.textLabel!.text = String(describing: georow.dt) + ":" + String(georow.latitude) + " " +  String(georow.longitude) + " " + String(georow.speed) + " " + String(georow.course)
        //cell.textLabel!.text = "z"
        
        return cell
    }
    
}

