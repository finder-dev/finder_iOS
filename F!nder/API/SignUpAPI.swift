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
                          completionHandler: @escaping (Result<SendEmailResponseDTO,Error>)-> Void) {
        
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
            guard let json = try? decoder.decode(SendEmailResponseDTO.self, from: data) else {
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
                         completionHandler: @escaping (Result<SendCodeResponseDTO,Error>)-> Void) {
        
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
            guard let json = try? decoder.decode(SendCodeResponseDTO.self, from: data) else {
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
                       completionHandler: @escaping (Result<SignUpResponseDTO,Error>)-> Void) {
        
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
            guard let json = try? decoder.decode(SignUpResponseDTO.self, from: data) else {
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
                           mbti: String?,
                           nickName: String?,
                           completionHandler: @escaping (Result<SocialLoginResponseDTO,Error>)-> Void) {
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
                let json = try! decoder.decode(SocialLoginResponseDTO.self, from: data)
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
            
            if !json.success {
                print("SendEmail : Network - sendEmailResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 로그아웃
    func requestLogout(completionHandler: @escaping (Result<LogoutResponse,Error>)-> Void) {
        let urlComponents = URLComponents(string: "https://finder777.com/api/logout")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST" // POST
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(LogoutResponse.self, from: data) else {
                return
            }
            print("======================================================================")
            print("Logout : Network - LogoutResponse => \(json.success)")
            if !json.success {
                print("Logout : Network - LogoutResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
}
