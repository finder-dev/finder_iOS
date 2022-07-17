//
//  DebateAPI.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct DebateAPI {
    
    //가장 많이 참여한 토론 조회
    func requestHotDebate(completionHandler: @escaping (Result<HotDebateResponse,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/hot")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "GET"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(HotDebateResponse.self, from: data) else {
                print("오류 : jsonDecode 실패")
                return
            }
            print("======================================================================")
            print("requestHotDebate : Network - HotDebateResponse => \(json.success)")
            if !json.success {
                print("requestHotDebate : Network - HotDebateResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    /*
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
     */
    
    // 새로운 토론 생성
    func requestMakeDebate(title:String,
                           optionA:String,
                           optionB:String,
                           completionHandler: @escaping (Result<MakeDebateResponse,Error>)-> Void) {
        
        let newDebate = MakeDebate(title: title, optionA: optionA, optionB: optionB)
        let bodyData = newDebate.parameters.percentEncoded()
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.httpBody = bodyData
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(MakeDebateResponse.self, from: data) else {
                return
            }
            
            print("======================================================================")
            print("MakeDebate : Network - MakeDebateResponse => \(json.success)")
            
            if !json.success {
                print("MakeDebate : Network - MakeDebateResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
}
