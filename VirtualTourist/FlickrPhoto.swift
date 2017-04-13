//
//  FlickrPhoto.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit

struct FlickrPhoto {
    
    // MARK: Properties
    
    let url: String
    
    // MARK: Initializers
    
    // construct a FlickrPhoto from a dictionary
    init(dictionary: [String:AnyObject]) {
        url = dictionary[FlickrClient.ResponseKeys.MediumURL] as! String
    }
    
    // Convert results to an array of FlickrPhotos
    static func flickrPhotosFromResults(_ results: [[String:AnyObject]]) -> [FlickrPhoto] {
        
        var flickrPhotos = [FlickrPhoto]()
        
        // iterate through array of dictionaries, each ParseStudent is a dictionary
        for result in results {
            flickrPhotos.append(FlickrPhoto(dictionary: result))
        }
        
        return flickrPhotos
    }
}
