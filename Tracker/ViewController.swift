//
//  ViewController.swift
//  Tracker
//
//  Created by Vikas Naik on 30/06/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    var city = ""
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    func getLocation() {
        progressBar.startAnimating()
        self.progressBar.isHidden = false
        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
        
    }
    @IBAction func refresh1(_ sender: UIButton) {
        getLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentlocation = location

            let latitude: Double = self.currentlocation!.coordinate.latitude
            let longitude: Double = self.currentlocation!.coordinate.longitude
            let speed: Double =
            self.currentlocation!.speed
            print("lat : "+String(latitude)+" -- "+"lng : "+String(longitude)+"speed : "+String(speed))
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.progressBar.stopAnimating()
                            self.progressBar.isHidden = true
                            self.location.text = city
                            self.city = "City : "+city
                            
                            self.speed.text = "Speed : "+String(speed)
                            
                            let now = Date()

                               let formatter = DateFormatter()

                               formatter.timeZone = TimeZone.current

                               formatter.dateFormat = "yyyy-MM-dd HH:mm"

                               let dateString = formatter.string(from: now)
                            self.time.text = dateString
                        }
                    }
                }
            }
        }
        print("City : "+city)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }

}

