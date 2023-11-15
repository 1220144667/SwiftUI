//
//  ContentView.swift
//  SwiftUIRegistration
//
//  Created by WN on 2023/11/2.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack {
                TextField("phone", text: $viewModel.username, prompt: Text("请输入手机号"))
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal)
                Divider()
                    .frame(height: 1)
                    .background(Color.rgb(240, 240, 240))
                    .padding(.horizontal)
                if !viewModel.isUsernameValid {
                    InputErrorView(iconName: "exclamationmark.circle.fill", text: "用户不存在")
                }
            }
            VStack {
                SecureField("password", text: $viewModel.password, prompt: Text("请输入密码"))
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal)
                Divider()
                    .frame(height: 1)
                    .background(Color.rgb(240, 240, 240))
                    .padding(.horizontal)
                if !viewModel.isPasswordValid || !viewModel.isPasswordCapitalLetter {
                    InputErrorView(iconName: "exclamationmark.circle.fill", text: "密码不正确")
                }
            }
            VStack {
                SecureField("confirm", text: $viewModel.confirm, prompt: Text("请再次输入密码"))
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal)
                Divider()
                    .frame(height: 1)
                    .background(Color.rgb(240, 240, 240))
                    .padding(.horizontal)
                if !viewModel.isConfirm {
                    InputErrorView(iconName: "exclamationmark.circle.fill", text: "两次输入的密码不一致")
                }
            }
            Button(action: {
                print("注册")
            }, label: {
                Text("注册")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.rgb(51, 51, 51))
                    .cornerRadius(10)
                    .padding(.horizontal)
            })
            .padding()
        }
    }
}

struct InputErrorView: View {
    
    var iconName = ""
    var text = ""
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(Color.rgb(251, 128, 128))
            Text(text)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(Color.rgb(251, 128, 128))
            Spacer()
        }
        .padding(.leading, 10)
    }
}

#Preview {
    ContentView()
}
