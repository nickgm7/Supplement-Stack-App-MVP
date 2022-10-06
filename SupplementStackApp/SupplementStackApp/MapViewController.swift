//
//  MapViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{


    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    
    //location manager
    private let locationManager = CLLocationManager()
    
    //arrays for map locations and distances *Attempt to combine and sort by distance later*
    var locations:[MKMapItem] = []
    var distances:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if(isLocationEnabled()){
            getPlaces()
        }
        
    }
    //return the amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // calling the model to get the city count
        return self.locations.count
    }
    //define what goes in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
        cell.layer.borderWidth = 1.0
        cell.placeNameLabel?.text = locations[indexPath.row].name
        cell.distanceLabel?.text = "\(String(distances[indexPath.row])) mi"
        cell.phoneLabel?.text = locations[indexPath.row].phoneNumber
        cell.addressLabel?.text = locations[indexPath.row].placemark.title
        return cell
    }
    //pin supplement stores nearby on map and list them in tableview
    func getPlaces(){
        
        let search = MKLocalSearch.Request()
        search.naturalLanguageQuery = "Supplements"
        let span = MKCoordinateSpan.init(latitudeDelta: 0.10, longitudeDelta: 0.10)
        search.region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        let results = MKLocalSearch(request: search)
        
        results.start{pin, _ in guard let pin = pin else{return}
            self.locations = pin.mapItems
            print(self.locations.count)
            if(self.locations.count > 1)
            {
                for i in 0...self.locations.count - 1
                {
                    let place = self.locations[i].placemark
                    //get distance to each pin and round to 1 decimal
                    var distance = self.locations[i].placemark.location?.distance(from: self.locationManager.location!)
                    distance = distance! / 1609
                    distance = Double(round(10 * distance!) / 10)
                    self.distances.insert(distance!, at: i)
                    print("distance to \(place.name!): \(self.distances[i]) vs \(distance!) miles")
                    let annotation1 = MKPointAnnotation()
                    annotation1.coordinate = place.location!.coordinate
                    annotation1.title = self.locations[i].name
                    annotation1.subtitle = place.subLocality
                    self.map.addAnnotation(annotation1)
                }
                //reloads the table with the pins
                self.locationTable.reloadData()
                print(self.distances.count)
                
            }
            
        }
        
        
    }
    //change the map type with toggle
    @IBAction func showMap(_ sender: Any) {
        switch(mapType.selectedSegmentIndex)
        {
        case 0:
            map.mapType = MKMapType.standard
            
        case 1:
            map.mapType = MKMapType.hybrid
            
        case 2:
            map.mapType = MKMapType.satellite
            
        default:
            map.mapType = MKMapType.standard
        }
    }
    //check if location is enabled
    func isLocationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
        return false
    }
}

//delegate methods for CLLocationManager
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways  {
            locationManager.requestLocation()
        }
        else{
            //******code here to go back to last screen for not accepting location services******
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.10, longitudeDelta: 0.10)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: false)
            getPlaces()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        //******code here to go back to last screen for not accepting location services******
    }
}


   

