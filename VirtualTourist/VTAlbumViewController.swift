//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: - VTAlbumViewController: UIViewController

class VTAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pin : Pin!
    var id : String!
    var region: MKCoordinateRegion!
    var pinLocation: CLLocationCoordinate2D!
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
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinLocation
        annotation.title = id
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newCollectionButton.isEnabled = true
        
        // Get the stack
        let stack = appDelegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Pin")
        fr.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        
        // Create the FetchedResultsController
        do {
            let pins = try stack.context.fetch(fr) as! [Pin]
            if pins.count <= 0 {
                let userInfo = [NSLocalizedDescriptionKey : "Missing pin"]
                throw NSError(domain: "VTAlbumViewController", code: 1, userInfo: userInfo)
            }
            pin = pins[0]
            
            guard let photoSet = pin.photos else {
                let userInfo = [NSLocalizedDescriptionKey : "Missing photo set"]
                throw NSError(domain: "VTAlbumViewController", code: 1, userInfo: userInfo)
            }
            
            photos = photoSetToArray(photoSet: photoSet)
            if photos.count <= 0 {
                fetchPhotos()
            } else {
                DispatchQueue.main.async {
                    self.collectionView!.reloadData()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchPhotos() {
        // Load the studentInformations and reload the table
        FlickrClient.sharedInstance().getByLocation(
            latitude: pinLocation.latitude,
            longitude: pinLocation.longitude,
            count: 20
        ) { (_ results: [String], _ error: NSError?) in
            if error != nil {
                //self.alertUserOfFailure(message: "Data download failed.")
                print("Data download failed.")
            } else {
                for photo in self.photos {
                    self.appDelegate.stack.context.delete(photo)
                    self.pin.removeFromPhotos(photo)
                }
                
                for photoUrl in results {
                    let photo = Photo(context: self.appDelegate.stack.context)
                    photo.url = photoUrl
                    self.pin.addToPhotos(photo)
                }
                
                self.appDelegate.stack.save()
                
                self.photos = self.photoSetToArray(photoSet: self.pin.photos!)
                
                DispatchQueue.main.async {
                    self.collectionView!.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.collectionView!.reloadData()
                }
            }
        }
    }
    
    func photoSetToArray(photoSet: NSSet?) -> [Photo] {
        return Array(photoSet as! Set<Photo>).sorted{ $0.url! > $1.url! }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        print(pin.photos!.count)
        return pin.photos!.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "VTAlbumViewCell",
            for: indexPath
            ) as! VTAlbumViewCell
        let photo = self.photos[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = UIImage(named: "TestImage")
        
        if let imageData = photo.imageData {
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData as Data)
            }
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
        let index = (indexPath as NSIndexPath).row
        let photo = photos[index]
        appDelegate.stack.context.delete(photo)
        pin.removeFromPhotos(photo)
        appDelegate.stack.save()
        
        photos.remove(at: index)
        collectionView.deleteItems(at: [indexPath])
    }
}
