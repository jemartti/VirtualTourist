//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

//extension FlickrClient {
//    
//    // MARK: GET Convenience Methods
//    
//    func getUserData(_ completionHandlerForGetUserData: @escaping (_ error: NSError?) -> Void) {
//        
//        /* Specify method */
//        var mutableMethod: String = Methods.UsersKey
//        mutableMethod = ClientHelpers.substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserKey, value: String(UdacityClient.sharedInstance().userKey!))!
//        
//        /* Make the request */
//        let _ = taskForGETMethod(mutableMethod) { (results, error) in
//            if let error = error {
//                completionHandlerForGetUserData(error)
//            } else {
//                // Parse out the requested UdacityUser
//                if let result = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
//                    UdacityClient.sharedInstance().user = UdacityUser.userFromResult(result)
//                    completionHandlerForGetUserData(nil)
//                } else {
//                    completionHandlerForGetUserData(NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUserData"]))
//                }
//            }
//        }
//    }
//    
//    // MARK: POST Convenience Methods
//    
//    func postSession(_ username: String, password: String, completionHandlerForPostSession: @escaping (_ error: NSError?) -> Void) {
//        
//        /* Specify HTTP body */
//        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
//        
//        /* Make the request */
//        let _ = taskForPOSTMethod(Methods.Account, jsonBody: jsonBody) { (results, error) in
//            if let error = error {
//                completionHandlerForPostSession(error)
//                return
//            }
//            
//            // Parse out the account and session information
//            if let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject],
//                let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
//                
//                // Make sure it's a valid account
//                if !(account[UdacityClient.JSONResponseKeys.AccountRegistered] as! Bool) {
//                    completionHandlerForPostSession(NSError(domain: "postSession registration", code: 0, userInfo: [NSLocalizedDescriptionKey: "That user is not registered"]))
//                }
//                
//                // Set the session data
//                UdacityClient.sharedInstance().userKey = account[UdacityClient.JSONResponseKeys.AccountKey] as? String
//                UdacityClient.sharedInstance().sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
//                
//                completionHandlerForPostSession(nil)
//            } else {
//                completionHandlerForPostSession(NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSession"]))
//            }
//        }
//    }
//    
//    // MARK: DELETE Convenience Methods
//    
//    func deleteSession(_ completionHandlerForDeleteSession: @escaping (_ error: NSError?) -> Void) {
//        
//        /* Specify HTTP cookies */
//        var xsrfCookie: HTTPCookie? = nil
//        let sharedCookieStorage = HTTPCookieStorage.shared
//        for cookie in sharedCookieStorage.cookies! {
//            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//        }
//        
//        /* Make the request */
//        let _ = taskForDELETEMethod(Methods.Account, xsrfCookie: xsrfCookie) { (results, error) in
//            if let error = error {
//                completionHandlerForDeleteSession(error)
//                return
//            }
//            
//            // Make sure we had a valid response
//            if let _ = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
//                // Clear the session data
//                UdacityClient.sharedInstance().userKey = nil
//                UdacityClient.sharedInstance().sessionID = nil
//                
//                completionHandlerForDeleteSession(nil)
//            } else {
//                completionHandlerForDeleteSession(NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteSession"]))
//            }
//        }
//    }
//}
