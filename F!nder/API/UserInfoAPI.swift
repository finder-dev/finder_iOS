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
}
