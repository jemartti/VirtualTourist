//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import Foundation

// MARK: - FlickrClient (Convenient Resource Methods)

extension FlickrClient {
    
    // MARK: GET Convenience Methods
    
    func getByLocation(
        latitude: Double,
        longitude: Double,
        count: Int,
        completionHandlerForGetByLocation: @escaping (_ results: [String], _ error: NSError?) -> Void
    ) {
        
        let parameters = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.APIKey: FlickrClient.ParameterValues.APIKey,
            FlickrClient.ParameterKeys.BoundingBox: bboxString(latitude: latitude, longitude: longitude),
            FlickrClient.ParameterKeys.SafeSearch: FlickrClient.ParameterValues.UseSafeSearch,
            FlickrClient.ParameterKeys.Extras: FlickrClient.ParameterValues.MediumURL,
            FlickrClient.ParameterKeys.Format: FlickrClient.ParameterValues.ResponseFormat,
            FlickrClient.ParameterKeys.NoJSONCallback: FlickrClient.ParameterValues.DisableJSONCallback
        ]

        /* Make the request */
        let _ = taskForGETMethod(parameters as [String:AnyObject]) { (results, error) in
            var photoStrings = [String]()
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetByLocation(photoStrings, error)
            } else {
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForGetByLocation(photoStrings, NSError(domain: "FlickrClient", code: 1, userInfo: userInfo))
                }
                
                guard let stat = results?[FlickrClient.ResponseKeys.Status] as? String, stat == FlickrClient.ResponseValues.OKStatus else {
                    sendError("Flickr API returned an error.")
                    return
                }

                guard let photosDictionary = results?[FlickrClient.ResponseKeys.Photos] as? [String:AnyObject] else {
                    sendError("Cannot find key '\(FlickrClient.ResponseKeys.Photos)' in results")
                    return
                }

                guard let photosArray = photosDictionary[FlickrClient.ResponseKeys.Photo] as? [[String: AnyObject]] else {
                    sendError("Cannot find key '\(FlickrClient.ResponseKeys.Photo)' in photosDictionary")
                    return
                }
                
                // Pull `count` random photos from the array
                for photo in photosArray.shuffled().prefix(count) {
                    photoStrings.append(photo[FlickrClient.ResponseKeys.MediumURL] as! String)
                }
                
                completionHandlerForGetByLocation(photoStrings, nil)
            }
        }
    }

    // MARK: Convenience method helpers
    
    private func bboxString(latitude: Double, longitude: Double) -> String {
        // ensure bbox is bounded by minimum and maximums
        let minimumLon = max(
            longitude - FlickrClient.Constants.SearchBBoxHalfWidth,
            FlickrClient.Constants.SearchLonRange.0
        )
        let minimumLat = max(
            latitude - FlickrClient.Constants.SearchBBoxHalfHeight,
            FlickrClient.Constants.SearchLatRange.0
        )
        let maximumLon = min(
            longitude + FlickrClient.Constants.SearchBBoxHalfWidth,
            FlickrClient.Constants.SearchLonRange.1
        )
        let maximumLat = min(
            latitude + FlickrClient.Constants.SearchBBoxHalfHeight,
            FlickrClient.Constants.SearchLatRange.1
        )
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
}
