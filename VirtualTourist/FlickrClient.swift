//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

//class FlickrClient : NSObject {
//    
//    // MARK: Properties
//    
//    // shared session
//    var session = URLSession.shared
//    
//    // authentication state
//    var sessionID: String? = nil
//    var userKey: String? = nil
//    var user: UdacityUser? = nil
//    
//    // MARK: Initializers
//    
//    override init() {
//        
//        super.init()
//        
//        session = {
//            let configuration = URLSessionConfiguration.default
//            configuration.timeoutIntervalForRequest = 5
//            configuration.timeoutIntervalForResource = 5
//            return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
//        }()
//    }
//    
//    // MARK: GET
//    
//    func taskForGETMethod(_ method: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: udacityURLWithPathExtension(method))
//        
//        /* Make the request */
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            
//            func sendError(_ error: String) {
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError("The request failed (likely due to a network issue). Check your settings and try again.")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            if statusCode < 200 || statusCode > 299 {
//                if statusCode == 403 {
//                    sendError("Invalid credentials.")
//                } else {
//                    sendError("The request failed due to a server error (\(statusCode)). Try again later.")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            
//            /* Parse the data and use the data (happens in completion handler) */
//            let range = Range(uncheckedBounds: (5, data.count))
//            let newData = data.subdata(in: range)
//            ClientHelpers.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
//        }
//        
//        /* Start the request */
//        task.resume()
//        
//        return task
//    }
//    
//    // MARK: POST
//    
//    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: udacityURLWithPathExtension(method))
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
//        
//        /* Make the request */
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            
//            func sendError(_ error: String) {
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError("The request failed (likely due to a network issue). Check your settings and try again.")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            if statusCode < 200 || statusCode > 299 {
//                if statusCode == 403 {
//                    sendError("Invalid credentials.")
//                } else {
//                    sendError("The request failed due to a server error (\(statusCode)). Try again later.")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            
//            /* Parse the data and use the data (happens in completion handler) */
//            let range = Range(uncheckedBounds: (5, data.count))
//            let newData = data.subdata(in: range)
//            ClientHelpers.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
//        }
//        
//        /* Start the request */
//        task.resume()
//        
//        return task
//    }
//    
//    // MARK: DELETE
//    
//    func taskForDELETEMethod(_ method: String, xsrfCookie: HTTPCookie?, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: udacityURLWithPathExtension(method))
//        request.httpMethod = "DELETE"
//        if let xsrfCookie = xsrfCookie {
//            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//        }
//        
//        /* Make the request */
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            
//            func sendError(_ error: String) {
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError("The request failed (likely due to a network issue). Check your settings and try again.")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            if statusCode < 200 || statusCode > 299 {
//                if statusCode == 403 {
//                    sendError("Invalid credentials.")
//                } else {
//                    sendError("The request failed due to a server error (\(statusCode)). Try again later.")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError("The request failed due to a server error. Try again later.")
//                return
//            }
//            
//            /* Parse the data and use the data (happens in completion handler) */
//            let range = Range(uncheckedBounds: (5, data.count))
//            let newData = data.subdata(in: range)
//            ClientHelpers.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
//        }
//        
//        /* Start the request */
//        task.resume()
//        
//        return task
//    }
//    
//    // MARK: Helpers
//    
//    // create a URL from parameters
//    private func udacityURLWithPathExtension(_ pathExtension: String? = nil) -> URL {
//        
//        var components = URLComponents()
//        components.scheme = UdacityClient.Constants.ApiScheme
//        components.host = UdacityClient.Constants.ApiHost
//        components.path = UdacityClient.Constants.ApiPath + (pathExtension ?? "")
//        
//        return components.url!
//    }
//    
//    // MARK: Shared Instance
//    
//    class func sharedInstance() -> UdacityClient {
//        
//        struct Singleton {
//            static var sharedInstance = UdacityClient()
//        }
//        
//        return Singleton.sharedInstance
//    }
//}
