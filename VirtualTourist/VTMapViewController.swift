//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: - VTMapViewController: UIViewController

class VTMapViewController: UIViewController {
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
    @IBAction func dropPin(_ sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizerState.began) {
            return
        }
        
        let location = getTappedLocation(mapView: self.mapView, gestureRecognizer: sender)
        
        // Add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = UUID().uuidString
        mapView.addAnnotation(annotation)
        
        
        let pin = Pin(context: appDelegate.stack.context)
        pin.id = annotation.title!
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
        pin.creationDate = Date() as NSDate
        
        appDelegate.stack.save()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.mapViewController = self
        loadSettings()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Get the stack
        let stack = appDelegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Pin")
        
        // Create the FetchedResultsController
        do {
            let pins = try stack.context.fetch(fr) as! [Pin]
            initialiseAnnotations(pins)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Administration
    
    private func alertUserOfFailure( message: String) {
        
        performUIUpdatesOnMain {
            let alertController = UIAlertController(
                title: "Action Failed",
                message: message,
                preferredStyle: UIAlertControllerStyle.alert
            )
            alertController.addAction(UIAlertAction(
                title: "Dismiss",
                style: UIAlertActionStyle.default,
                handler: nil
            ))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func loadSettings() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            saveSettings()
        } else {
            let coordinate = CLLocationCoordinate2DMake(
                UserDefaults.standard.double(forKey: "mapLat"),
                UserDefaults.standard.double(forKey: "mapLong")
            )
            let span = MKCoordinateSpanMake(
                UserDefaults.standard.double(forKey: "mapLatDelta"),
                UserDefaults.standard.double(forKey: "mapLongDelta")
            )
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "mapLat")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "mapLong")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "mapLatDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "mapLongDelta")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Supplementary Functions
    
    private func getTappedLocation(mapView: MKMapView, gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
    
    // Update the pins on the map
    private func initialiseAnnotations(_ pins: [Pin]) {
        print("Initialising")
        var annotations = [MKPointAnnotation]()
        
        for pin in pins {
            print(pin.id!)
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.title = pin.id
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }

    // Displays the Create View
    func loadAlbum(id: String, pinLocation: CLLocationCoordinate2D) {
        let albumVC = storyboard!.instantiateViewController(
            withIdentifier: "VTAlbumViewController"
        ) as! VTAlbumViewController
        
        albumVC.id = id
        albumVC.region = mapView.region
        albumVC.pinLocation = pinLocation
        self.navigationController?.pushViewController(albumVC, animated: true)
    }

}

// MARK: - VTMapViewController: MKMapViewDelegate

extension VTMapViewController: MKMapViewDelegate {
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect: MKAnnotationView) {
        mapView.deselectAnnotation(didSelect.annotation!, animated: false)
        loadAlbum(id: didSelect.annotation!.title!!, pinLocation: didSelect.annotation!.coordinate)
    }
}
