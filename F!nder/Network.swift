//
//  Network.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/22.
//

import Foundation

struct Network {
    
    // MARK : 이메일 확인
    func requestAuthEmail(email:String,
                          completionHandler: @escaping (Result<SendEmailResponse,Error>)-> Void) {
        
        let emailData = SendEmail(email: email)
        let bodyData = emailData.parameters.percentEncoded()
        let urlComponents = URLComponents(string: "https://finder777.com/api/mail/send")
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST" // POST
        requestURL.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(SendEmailResponse.self, from: data) else {
                return
            }
            print("======================================================================")
            print("SendEmail : Network - sendEmailResponse => \(json.success)")
            print("SendEmail : Network - sendEmailResponse => \(json.errorResponse?.errorMessages)")
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // MARK : - 코드 확인
    func requestCodeAuth(code:String,
                         email: String,
                         completionHandler: @escaping (Result<SendCodeResponse,Error>)-> Void) {
        
        let codeData = SendCode(code: code, email: email)
        let bodyData = codeData.parameters.percentEncoded()
        let urlComponents = URLComponents(string: "https://finder777.com/api/mail/auth")
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST" // POST
        requestURL.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(SendCodeResponse.self, from: data) else {
                return
            }
            print("======================================================================")
            print("SendEmail : Network - sendEmailResponse => \(json.success)")
            print("SendEmail : Network - sendEmailResponse => \(json.errorResponse?.errorMessages)")
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
}
