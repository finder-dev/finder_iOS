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
}
