//
//  MovieService.swift
//  faketube
//
//  Created by Daniel Freitas on 14/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import Foundation

class MovieService {
    var endpoint: String?
    
    static func sharedInstance() -> MovieService {
        return MovieService()
    }
    
    func get(url: String, completion: @escaping (Int) -> ()) {
        guard let endpoint = URL(string: url) else {
            return
        }
        
        print("URL:", endpoint)
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            guard error != nil else {
                print("Error", error)
                completion(0)
                return
            }
            
            print ("Res:", response)
            print ("Data:", data)
            completion(1)
        }
        
        task.resume()
        
    }
        
}
