//
//  SpotDetailViewController.swift
//  Snacktacular
//
//  Created by song on 3/11/22.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts


class SpotDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
//    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    
    
    var spot: Spot!
    let regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getLocation()
        if spot == nil {
            spot = Spot()
        }
        setupMapView()
        updateUserInterface()
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUserInterface() {
        nameTextField.text = spot.name
        addressTextField.text = spot.address
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(spot)
        mapView.setCenter(spot.coordinate, animated: true)
    }
    
    func updateFromInterface() {
        spot.name = nameTextField.text!
        spot.address = addressTextField.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func emptyTestFunc() {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromInterface()
        spot.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                // ERROR during save occured
                self.oneButtonAlert(title: "😡 Save Failed", message: "For some reason could not save to the cloud.")
            }
        }
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
            leaveViewController()
        
    }
    
    

    @IBAction func locationButtonPressed(_ sender: UIBarButtonItem) {
        
        let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                
                // Display the autocomplete view controller.
                    present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
}


extension SpotDetailViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
      spot.name = place.name ?? "Unknown Place"
      spot.address = place.formattedAddress ?? "Unknown Address"
      spot.coordinate = place.coordinate
      updateUserInterface()
      
      dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }


}

extension SpotDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        // Creating a CLLocationManager will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("👮‍♀️👮‍♀️ Checking authentication status.")
        handleAuthenticalStatus(status: status)
    }
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus){
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app.")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to enable device settings and enable location services for this app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("😡😡 DEVELOPER ALERT: Unknown case of status in handleAuthenticalStatus \(status)")
        }
        
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("😡😡 Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Deal with change in location

        
        let currentLocation = locations.last ?? CLLocation()
        print("🗺 Current location is \(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)")
        
        var name = ""
        var address = ""
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print ("😡 ERROR: retrieving place. \(error!.localizedDescription)")
            }
            if placemarks != nil {
                // get the first placemark
                let placemark = placemarks?.last
                
                // assign placemark to locationName
                name = placemark?.name ?? "Name Unknown"
                if let postalAddress = placemark?.postalAddress {
                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                }
            }
            else {
                print ("😡 ERROR: retrieving placemark.")
//                address = "Could not find location"
            }
            if self.spot.name == "" && self.spot.address == "" {
                self.spot.name = name
                self.spot.address = address
                self.spot.coordinate = currentLocation.coordinate
            }
            
            self.mapView.userLocation.title = name
            self.mapView.userLocation.subtitle = address.replacingOccurrences(of: "\n", with: ", ")

            self.updateUserInterface()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Deal with error
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
    
}

