//
//  VTAlbumViewController.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: - VTAlbumViewController: UIViewController, UICollectionViewDataSource

class VTAlbumViewController: UIViewController, UICollectionViewDataSource {
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pin : Pin!
    var id : String!
    var pinLocation : CLLocationCoordinate2D!
    var photos : [Photo]!
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    // MARK: Actions
    
    @IBAction func newCollection(_ sender: Any) {
        fetchPhotos()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        newCollectionButton.isEnabled = false
        newCollectionButton.title = "New Collection"
        
        let region = MKCoordinateRegionMakeWithDistance(pinLocation, 50000, 50000)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinLocation
        annotation.title = id
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newCollectionButton.isEnabled = true
        
        // Load existing Pin (including photo set)
        let stack = appDelegate.stack
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Pin")
        fr.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        do {
            let pins = try stack.context.fetch(fr) as! [Pin]
            
            if pins.count <= 0 {
                let userInfo = [NSLocalizedDescriptionKey : "Missing pin"]
                throw NSError(domain: "VTAlbumViewController", code: 1, userInfo: userInfo)
            }
            
            // THIS Pin
            pin = pins[0]
            
            // Load Photo set (if it exists)
            guard let photoSet = pin.photos else {
                let userInfo = [NSLocalizedDescriptionKey : "Missing photo set"]
                throw NSError(domain: "VTAlbumViewController", code: 1, userInfo: userInfo)
            }
            photos = photoSetToArray(photoSet: photoSet)
            if photos.count <= 0 {
                // Fetch a new Photo set from Flickr
                fetchPhotos()
            } else {
                // Display the existing Photo set
                self.collectionView.reloadData()
            }
        } catch _ as NSError {
            self.alertUserOfFailure(message: "Data load failed.")
        }
    }
    
    // MARK: Administration
    
    private func alertUserOfFailure( message: String) {
        
        DispatchQueue.main.async {
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
    
    // MARK: Supplementary Functions
    
    // Converts a CoreData photoSet to a sorted Array of Photos
    func photoSetToArray(photoSet: NSSet?) -> [Photo] {
        return Array(photoSet as! Set<Photo>).sorted{ $0.url! > $1.url! }
    }
    
    // Initiates a load of a new set of photos from Flickr
    func fetchPhotos() {
        
        FlickrClient.sharedInstance().getByLocation(
            latitude: pinLocation.latitude,
            longitude: pinLocation.longitude,
            count: 20
        ) { (_ results: [String], _ error: NSError?) in
        
            if error != nil {
                self.alertUserOfFailure(message: "Data download failed.")
            } else {
                
                // Clean up existing Photo set
                for photo in self.photos {
                    self.appDelegate.stack.context.delete(photo)
                    self.pin.removeFromPhotos(photo)
                }
                
                // Update UI state for an empty response
                if results.count == 0 {
                    self.appDelegate.stack.save()
                    
                    DispatchQueue.main.async {
                        self.newCollectionButton.isEnabled = false
                        self.newCollectionButton.title = "No Images Found"
                    }
                    return
                }
                
                // Create Photo set from Flickr response
                for photoUrl in results {
                    let photo = Photo(context: self.appDelegate.stack.context)
                    photo.url = photoUrl
                    self.pin.addToPhotos(photo)
                }
                self.appDelegate.stack.save()
                
                // Update local Photo set
                self.photos = self.photoSetToArray(photoSet: self.pin.photos!)
                
                // Update CollectionView data
                DispatchQueue.main.async {
                    self.collectionView.setContentOffset(CGPoint.zero, animated: false)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - VTAlbumViewController: UICollectionViewDelegate

extension VTAlbumViewController: UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return pin.photos!.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        // Fetch a cell and set a placeholder image
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "VTAlbumViewCell",
            for: indexPath
        ) as! VTAlbumViewCell
        cell.imageView?.image = UIImage(named: "Placeholder")
        
        // Fetch the Photo corresponding to the cell
        let photo = self.photos[(indexPath as NSIndexPath).row]
        
        // If the image has been loaded, set it immediately
        // Otherwise, download the image Data and set it
        if let imageData = photo.imageData {
            cell.imageView?.image = UIImage(data: imageData as Data)
        } else if let url = photo.url {
            DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
                if let imageData = try? Data(contentsOf: URL(string: url)!) {
                    photo.imageData = imageData as NSData
                    self.appDelegate.stack.save()
                    
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Fetch the Photo information
        let index = (indexPath as NSIndexPath).row
        let photo = photos[index]
        
        // Delete the selected Photo
        appDelegate.stack.context.delete(photo)
        pin.removeFromPhotos(photo)
        appDelegate.stack.save()
        
        // Update local data and UI
        photos.remove(at: index)
        collectionView.deleteItems(at: [indexPath])
    }
}
