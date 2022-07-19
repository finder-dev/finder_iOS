//
//  CommunityAPI.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct CommunityAPI {
    
    var isPaginating = false
    
    // 커뮤니티 댓글순 조회
    func requestHotCommunity(completionHandler: @escaping (Result<HotCommunityResponse,Error>)-> Void) {
        
        let urlComponents = URLComponents(string: "https://finder777.com/api/community/hot")
        
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
            guard let json = try? decoder.decode(HotCommunityResponse.self, from: data) else {
                print("오류 : HotCommunityResponse jsonDecode 실패")
                return
            }
            print("======================================================================")
            print("requestHotCommunity : Network - HotCommunityResponse => \(json.success)")
            if !json.success {
                print("requestHotCommunity : Network - HotCommunityResponse => \(json.errorResponse?.errorMessages)")
            }
            print("======================================================================")
            completionHandler(.success(json))
        }
        task.resume()
    }
    
    // 전체 커뮤니티 글 조회
    mutating func requestEveryCommuityData(pagination: Bool = false,
                                  mbti:String?,
                                  orderBy: String,
                                  page: Int,
                                  completionHandler: @escaping (Result<EveryCommunityResponse,Error>)-> Void) {
        
        var urlComponents = URLComponents()
        if mbti == nil {
            urlComponents = URLComponents(string: "https://finder777.com/api/community?orderBy=\(orderBy)&page=\(page)")!
        } else {
            urlComponents = URLComponents(string: "https://finder777.com/api/community?mbti=\(mbti!)orderBy=\(orderBy)&page=\(page)")!
        }

        if mbti != nil {
            print("mbti is not nil")
        }

        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        var requestURL = URLRequest(url: (urlComponents.url)!)
        requestURL.httpMethod = "GET"
        requestURL.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data,error == nil else {
                debugPrint("error - \(error?.localizedDescription)")
                completionHandler(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            guard let json = try? decoder.decode(EveryCommunityResponse.self, from: data) else {
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
//            if pagination {
//                self.isPaginating = false
//            }
        }
        task.resume()
    }
}
