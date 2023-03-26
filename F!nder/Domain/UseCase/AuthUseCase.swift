//
//  AuthUseCase.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/26.
//

import Foundation

protocol AuthUseCase {
    func login()
    func logout()
}

final class DefaultAuthUseCase: AuthUseCase {

    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func login() {
        authRepository.login()
    }
    
    func logout() {
        authRepository.logout()
    }
}
