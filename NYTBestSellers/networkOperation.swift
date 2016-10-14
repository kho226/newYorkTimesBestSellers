//
//  networkOperation.swift
//  NYTBestSellers
//
//  Created by Kyle Ong on 10/1/16.
//  Copyright © 2016 Kyle Ong. All rights reserved.
//
//  Instantiate network config.
//  Download JSON

import Foundation
import Alamofire
import Kingfisher

class NetworkOperation{
    
    lazy var config:URLSessionConfiguration = URLSessionConfiguration.default//default configuration
    
    lazy var session: URLSession = URLSession(configuration: self.config)
    
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL){
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: @escaping JSONDictionaryCompletion){
        let request = URLRequest(url: queryURL as URL)
        let dataTask = session.dataTask(with: request){( data, response, error) in
            //check HTTP response for succesful GET Request
            
            if let httpResponse = response as? HTTPURLResponse{
                switch (httpResponse.statusCode){
                case 200: //create JSON object
                    do{
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options:[])
                            as! [String: AnyObject]
                        completion(jsonDictionary)
                    }catch let error {
                        print ("JSON Serialization Failed. Error: \(error)")
                    }
                default:
                    print("GET Request not succesful. HTTP Status Code: \(httpResponse.statusCode)")
                }
                
            }else {
                print ("Not a valid HTTP Response")
            }
            
            //create JSON object with data
            
        }
        dataTask.resume()
    }
}
