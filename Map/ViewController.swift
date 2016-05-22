//
//  ViewController.swift
//  Map
//
//  Created by mojado on 21.05.16.
//  Copyright © 2016 mojado. All rights reserved.
// 
// Bei 20 Minuten im Video weiter machen





import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var coreLocationManager = CLLocationManager()
    var locationManager: LocationManager!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManager.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)) || coreLocationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)){
            
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil {
                coreLocationManager.requestAlwaysAuthorization()
            }else{
                print("No description provided")
            }
        }else{
            getLocation()
        }
    }

    func getLocation(){
        locationManager.startUpdatingLocationWithCompletionHandler{(latitude,longitude,status,verboseMessage,error)->() in
        self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    func displayLocation(location:CLLocation){
        
        mapView.setRegion(MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),span:MKCoordinateSpanMake(0.02, 0.02)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    
    
       locationManager.reverseGeocodeLocationWithCoordinates(location) { (reverseGecodeInfo, placemark, error ) -> Void in
         let address = reverseGecodeInfo?.objectForKey("formattedAddress") as! String
         self.locationInfo.text = address
       }
    
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted{
            getLocation()
        }
    }
    
    
    @IBAction func UpdateLocation(sender: AnyObject) {
        
        getLocation()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

