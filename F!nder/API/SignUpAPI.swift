//
//  Network.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/22.
//

import Foundation

struct SignUpAPI {
    
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
    
    // MARK : - 이메일 인증 코드 확인
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
    
    // MARK : - 닉네임 중복 확인
    func requestCheckNickname(nickname: String,
                              completionHandler: @escaping (Result<SendEmailResponse,Error>)-> Void) {
        let urlComponents = URLComponents(string: "https://finder777.com/api/duplicated/nickname?nickname=\(nickname)")
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
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
    
    // MARK : - 일반 회원가입
    func requestSignUp(email: String,
                       password: String,
                       mbti:String,
                       nickname:String,
                       completionHandler: @escaping (Result<SignUpResponse,Error>)-> Void) {
        
        let codeData = SendSignUp(email: email, password: password, mbti: mbti, nickname: nickname)
        let bodyData = codeData.parameters.percentEncoded()
        let urlComponents = URLComponents(string: "https://finder777.com/api/signup")
        
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
            guard let json = try? decoder.decode(SignUpResponse.self, from: data) else {
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
    
    // MARK : - 소셜 로그인
    func requestOAuthLogin(userType: String,
                           token: String,
                           mbti: String,
                           nickName: String,
                           completionHandler: @escaping (Result<SocialLoginResponse,Error>)-> Void) {
        print("=========================requestOAuthLogin=============================================")
        
        let codeData = SendSocialLogin(userType: userType,
                                       mbti: mbti,
                                       nickname: nickName)
        
        let bodyData = codeData.parameters.percentEncoded()
        let urlComponents = URLComponents(string: "https://finder777.com/api/oauth/login")
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST" // POST
        requestURL.httpBody = bodyData
        print("Bearer " + token)
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data, error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let json = try! decoder.decode(SocialLoginResponse.self, from: data)
                print("======================================================================")
                print("SendSocialLogin : Network - socialLoginResponse => \(json.success)")
                if !json.success {
                    print("SendSocialLogin : Network - socialLoginResponse => \(json.errorResponse?.errorMessages)")
                }
                print("======================================================================")
                completionHandler(.success(json))
            } catch {
                guard let error = error as? DecodingError else {
                    return
                }
                print(error)
//                switch error {
//                case .dataCorrupted(let context):
//                    print(context.codingPath, context.debugDescription, context.underlyingError ?? "", separator: "\n")
//                default :
//                    return
//                }

            }
            
//            guard let json = try? decoder.decode(SocialLoginResponse.self, from: data) else {
//                let error = as? DecodingError
//                print("error - decode error")
//                return
//            }
//            print("======================================================================")
//            print("SendSocialLogin : Network - socialLoginResponse => \(json.success)")
//            if !json.success {
//                print("SendSocialLogin : Network - socialLoginResponse => \(json.errorResponse?.errorMessages)")
//            }
//            print("======================================================================")
//            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // MARK : - 일반 로그인
    func requestLogin(email:String, password:String,
                      completionHandler: @escaping (Result<LoginResponse,Error>)-> Void) {
        let emailData = SendLogin(email: email, password: password)
        let bodyData = emailData.parameters.percentEncoded()
        let urlComponents = URLComponents(string: "https://finder777.com/api/login")
        
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
            guard let json = try? decoder.decode(LoginResponse.self, from: data) else {
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
