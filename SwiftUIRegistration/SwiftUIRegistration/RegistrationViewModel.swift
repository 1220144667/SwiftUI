//
//  RegistrationViewModel.swift
//  SwiftUIRegistration
//
//  Created by WN on 2023/11/3.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    
    //输入
    @Published var username = ""
    @Published var password = ""
    @Published var confirm = ""
    
    //输出
    @Published var isUsernameValid = false
    @Published var isPasswordValid = false
    @Published var isPasswordCapitalLetter = false
    @Published var isConfirm = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        //用户名校验
        $username
            .receive(on: RunLoop.main)
            .map { $0.count >= 2 }
            .assign(to: \.isUsernameValid, on: self)
            .store(in: &cancellableSet)
        //密码校验
        $password
            .receive(on: RunLoop.main)
            .map { $0.count >= 6 }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellableSet)
        //密码大写校验
        $password
            .receive(on: RunLoop.main)
            .map { password in
                let pattern = "[A-Z]"
                if let _ = password.range(of: pattern, options: .regularExpression) {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isPasswordCapitalLetter, on: self)
            .store(in: &cancellableSet)
        //两次密码输入是否相同
        Publishers.CombineLatest($password, $confirm)
            .receive(on: RunLoop.main)
            .map { password, confirm in
                !password.isEmpty && (password == confirm)
            }
            .assign(to: \.isConfirm, on: self)
            .store(in: &cancellableSet)
    }
}
