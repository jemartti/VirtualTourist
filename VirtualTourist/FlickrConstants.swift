//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

// MARK: - Constants

extension FlickrClient {
    
    // MARK: Constants
    
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Parameter Keys
    
    struct ParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
        static let Page = "page"
    }
    
    // MARK: Parameter Values
    
    struct ParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "3c31ae48a31f2bc9a5eb3c455378e2e0"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    }
    
    // MARK: Response Keys
    
    struct ResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Response Values
    
    struct ResponseValues {
        static let OKStatus = "ok"
    }
}
