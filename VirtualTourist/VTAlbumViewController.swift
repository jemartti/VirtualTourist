//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import MapKit

// MARK: - VTAlbumViewController: UIViewController

class VTAlbumViewController: UIViewController {
    
    // MARK: Properties
    
    var id : String!
    var region: MKCoordinateRegion!
    var pinLocation: CLLocationCoordinate2D!
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    // MARK: Actions
    
    @IBAction func newCollection(_ sender: Any) {
        print("New Collection")
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        newCollectionButton.isEnabled = false
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinLocation
        annotation.title = id
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newCollectionButton.isEnabled = true
    }
}
