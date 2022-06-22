//
//  Network.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/22.
//

import Foundation

struct Network {
    let domain = "finder777.com"
    
    func requestAuthEmail(email:String) {
//        let url = URL(string: "finder777.com/api/mail/send")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlComponents = URLComponents(string: "finder777.com/api/mail/send")!
        let query = URLQueryItem(name: "email", value: email)
        urlComponents.queryItems?.append(query)
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("error - \(error)")
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
//            print(response)
            
            let decoder = JSONDecoder()
            let response = try? decoder.decode(Response.self, from: data)
            let message = response?.message
            print(message)
//            do  {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
//            }
        }
        dataTask.resume()
    }
}

struct Response : Codable {
    let message : String
}
