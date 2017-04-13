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

class VTAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties
    
    var id : String!
    var region: MKCoordinateRegion!
    var pinLocation: CLLocationCoordinate2D!
    var flickrPhotos: [FlickrPhoto]!
    
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
        
        
        flickrPhotos = [FlickrPhoto]()
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newCollectionButton.isEnabled = true
    }
    
    func fetchPhotos() {
        // Load the studentInformations and reload the table
        FlickrClient.sharedInstance().getByLocation(latitude: pinLocation.latitude, longitude: pinLocation.longitude) { (_ results: [FlickrPhoto], _ error: NSError?) in
            if error != nil {
                //self.alertUserOfFailure(message: "Data download failed.")
                print("Data download failed.")
            } else {
                self.flickrPhotos = results
                performUIUpdatesOnMain {
                    self.collectionView!.reloadData()
                }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        print(flickrPhotos.count)
        return flickrPhotos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "VTAlbumViewCell",
            for: indexPath
            ) as! VTAlbumViewCell
        let flickrPhotos = self.flickrPhotos[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: "TestImage")
        
        if let imageData = try? Data(contentsOf: URL(string: flickrPhotos.url)!) {
            performUIUpdatesOnMain {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
