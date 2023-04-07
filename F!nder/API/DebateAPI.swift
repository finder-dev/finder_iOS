//
//  DebateAPI.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct DebateAPI {
    
    //가장 많이 참여한 토론 조회
    func requestHotDebate(completionHandler: @escaping (Result<HotDebateResponseDTO,Error>)-> Void) {
        
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
            guard let json = try? decoder.decode(HotDebateResponseDTO.self, from: data) else {
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
    
    // 새로운 토론 생성
    func requestMakeDebate(title:String,
                           optionA:String,
                           optionB:String,
                           completionHandler: @escaping (Result<MakeDebateResponseDTO,Error>)-> Void) {
        
        let httpbody = "{\"title\" : \"\(title)\",\"optionA\" : \"\(optionA)\",\"optionB\" : \"\(optionB)\"}"
        let data = httpbody.data(using: String.Encoding.utf8)
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
                
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.httpBody = data
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(MakeDebateResponseDTO.self, from: data) else {
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
    
    // 전체 토론조회
    func requestEveryDebateData(state:String = "PROCEEDING",
                                         page:Int,
                                         completionHandler: @escaping (Result<EveryDebateResponseDTO,Error>)-> Void) {
        
        var urlComponents = URLComponents(string: "https://finder777.com/api/debate?page=\(page)&state=\(state)")!
    
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents.url)!)
        requestURL.httpMethod = "GET"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(EveryDebateResponseDTO.self, from: data) else {
                print("오류 : HotCommunityResponse jsonDecode 실패")
                return
            }
            print("======================================================================")
            print("EveryCommuityData : Network - EveryCommunityResponse => \(json.success)")
            if !json.success {
                print("EveryCommuityData : Network - EveryCommunityResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 토론 참여
    func requestVoteDebate(debateID:Int,
                           option:String,
                           completionHandler: @escaping (Result<VoteDebateResponseDTO,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/\(debateID)")
        let httpbody = "{\"option\" : \"\(option)\"}"
        let data = httpbody.data(using: String.Encoding.utf8)
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.httpBody = data
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(VoteDebateResponseDTO.self, from: data) else {
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
    
    // 토론 자세히 보기
    func requestDebateDetail(debateID:Int,
                             completionHandler: @escaping (Result<DetailDebateResponseDTO,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/\(debateID)")
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
            guard let json = try? decoder.decode(DetailDebateResponseDTO.self, from: data) else {
                print("json decode error\(error?.localizedDescription)")
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
    
    // 새 댓글 생성
    func requestNewComment(debateID:Int,
                           content:String,
                           completionHandler: @escaping (Result<DebateCommentResponseDTO,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/\(debateID)/answers")
        let httpbody = "{\"content\" : \"\(content)\"}"
        let data = httpbody.data(using: String.Encoding.utf8)
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.httpBody = data
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        requestURL.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(DebateCommentResponseDTO.self, from: data) else {
                return
            }
            
            print("======================================================================")
            print("DebateComment : Network - DebateCommenResponse => \(json.success)")
            
            if !json.success {
                print("DebateCommen : Network - DebateCommenResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 토론 신고
    func reportDebate(debateId:Int,
                      completionHandler: @escaping (Result<SendCodeResponse,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/\(debateId)/report")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
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
            print("reportDebate : Network - reportDebateResponse => \(json.success)")
            
            if !json.success {
                print("reportDebate : Network - reportDebateResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    func reportDebateComment(answerId:Int,
                             completionHandler: @escaping (Result<SendCodeResponse,Error>)-> Void) {
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/answers/\(answerId)/report")
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "POST"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
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
            print("reportDebateComment : Network - reportDebateComment => \(json.success)")
            
            if !json.success {
                print("reportDebateComment : Network - reportDebateComment => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 토론 댓글 삭제
    func requestDeleteDebateComment(answerId:Int,
                                    completionHandler: @escaping (Result<SendCodeResponse,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/debate/answers/\(answerId)")
        
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
                return
            }
            
            print("======================================================================")
            print(" requestDeleteDebateComment: Network -  requestDeleteDebateComment => \(json.success)")
            
            if !json.success {
                print(" requestDeleteDebateComment: Network - requestDeleteDebateComment => \(json.errorResponse?.errorMessages)")
            }
            
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
}
