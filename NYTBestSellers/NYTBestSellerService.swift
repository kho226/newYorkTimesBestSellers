//
//  NYTBestSellerService.swift
//  NYTBestSellers
//
//  Created by Kyle Ong on 10/1/16.
//  Copyright © 2016 Kyle Ong. All rights reserved.
//

import Foundation

/*"http://api.nytimes.com/svc/books/v3/lists/\(date)/\(category).json" */


struct NYTBestSellerService {
    
    let nytAPIKey: String
    
    let nytBaseURL: NSURL?
    
    init(APIkey: String){
        self.nytAPIKey = APIkey
        self.nytBaseURL = NSURL(string:"https://api.nytimes.com/svc/books/v3/lists/overview.json\(nytAPIKey)/")
    }
    
    /* func currentWeatherFromJSONDict(jsonDictionary: [String: AnyObject]?) -> CurrentWeather?{
     if let currentWeatherDict = jsonDictionary?["currently"] as? [String: AnyObject]{
     return CurrentWeather(weatherDict: currentWeatherDict)
     }else {
     print ("jsonDictionary returned nil for 'currently' key")
     return nil
     }
     } */
    
    /*
    func getAllBooks(lat: Double, lon: Double, completion:(Book? -> Void)){// -> left off right here
        if let nytURL = NSURL(string: "\(date),\(category)", relativeTo: nytBaseURL as URL?) {
            let networkOperation = NetworkOperation(url: forecastURL)
            networkOperation.downloadJSONFromURL{( JSONDictionary) in
                let forecast = Forecast(weatherDict: JSONDictionary)
                completion(forecast)
            }
            
        }else{
            print("Could not construct a valid URL")
        }
    } */
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = Reachability.init()!
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            
            return (networkStatus != 0)
        }
    }

    
}
