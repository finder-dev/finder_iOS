//
//  UserInfoAPI.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct UserInfoAPI {
    
    // 사용자 정보 가져오기
    func requestUserInfo(completionHandler: @escaping (Result<UserInfoResponse,Error>)-> Void) {
        let urlComponents = URLComponents(string: "https://finder777.com/api/users")
        
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
            guard let json = try? decoder.decode(UserInfoResponse.self, from: data) else {
                print("오류 : jsonDecode 실패")
                return
            }
            print("======================================================================")
            print("RequestUserInfo : Network - UserInfoResponse => \(json.success)")
            if !json.success {
                print("RequestUserInfo : Network - UserInfoResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    //회원 탈퇴
    func requestDeleteUser(completionHandler: @escaping (Result<SendCodeResponse,Error>)-> Void) {
        let urlComponents = URLComponents(string: "https://finder777.com/api/users")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "DELETE"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(SendCodeResponse.self, from: data) else {
                print("오류 : requestDeleteUser jsonDecode 실패")
                return
            }
            print("======================================================================")
            print("requestDeleteUser : Network - requestDeleteUser => \(json.success)")
            if !json.success {
                print("requestDeleteUser : Network - requestDeleteUser => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // MARK : - 닉네임 중복 확인
    func requestCheckNickname(nickname: String,
                              completionHandler: @escaping (Result<SendEmailResponse,Error>)-> Void) {
        
        let urlString = "https://finder777.com/api/duplicated/nickname?nickname=\(nickname)"
        
//        let urlComponents = URLComponents(string: "https://finder777.com/api/duplicated/nickname?nickname=\(nickname)")
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "GET"
        
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
    
    // 사용자 정보 수정
    func requestChangeUserInfo(nickName:String,
                               mbti:String,
                               password:String?,
                               completionHandler: @escaping (Result<ChangeUserInfoResponse,Error>)-> Void) {
        
        var httpbody = ""
        
        if let password = password {
            httpbody = "{\"mbti\" : \"\(mbti)\",\"nickname\" : \"\(nickName)\",\"password\" : \"\(password)\"}"
        } else {
            httpbody = "{\"mbti\" : \"\(mbti)\",\"nickname\" : \"\(nickName)\"}"
        }

        let data = httpbody.data(using: String.Encoding.utf8)
        let urlComponents = URLComponents(string: "https://finder777.com/api/users")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
                
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "PATCH"
        requestURL.httpBody = data
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(ChangeUserInfoResponse.self, from: data) else {
                return
            }
            
            print("======================================================================")
            print("requestChangeUserInfo : Network - requestChangeUserInfo => \(json.success)")
            
            if !json.success {
                print("requestChangeUserInfo : Network - requestChangeUserInfo => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 사용자 차단
    func requestBlockUser(userID:Int,
                          completionHandler: @escaping (Result<SendEmailResponse,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/users/block")
        let httpbody = "{\"blockUserId\" : \"\(userID)\"}"
        let data = httpbody.data(using: String.Encoding.utf8)
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
                
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.httpBody = data
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        requestURL.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
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
            print("requestBlockUser : Network - requestBlockUse => \(json.success)")
            
            if !json.success {
                print("requestBlockUse : Network - requestBlockUse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
        
        
    }
    
}
