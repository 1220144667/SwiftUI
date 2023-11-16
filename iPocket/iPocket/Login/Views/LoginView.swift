//
//  LoginView.swift
//  ZMarket
//
//  Created by WN on 2023/9/23.
//

import SwiftUI
import AlertToast

struct LoginView: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Image(.loginHeadBg)
                    .resizable()
                    .scaledToFit()
                Spacer()
                    .frame(height: 61)
                LoginInputView(phone: $viewModel.mobile, code: $viewModel.code, remaining: $viewModel.remaining) {
                    viewModel.queryRuleImageList()
                }
                Spacer()
                    .frame(height: 64)
                Button(action: {
                    loginButtonEvent()
                }, label: {
                    Text("登录")
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.size.width - 84, height: 54)
                .background(viewModel.enableLogin ? Color.theme : Color.rgb(187, 187, 187))
                .cornerRadius(27)
                Spacer()
                LoginProtocolView(isSelected: $viewModel.agree)
                Spacer()
                    .frame(height: 64)
            }
            .edgesIgnoringSafeArea(.all)
            .toast(isPresenting: $viewModel.isShowToast) {
                AlertToast(type: .regular, title: viewModel.toastMessage)
            }
            //展示图片验证码
            if viewModel.isShowImageView {
                LoginImagesView(imageTitle: $viewModel.imageTitle, images: $viewModel.images) { val in
                    viewModel.sendSmsCode(val)
                }
            }
        }
    }
    
    private func loginButtonEvent() {
        if viewModel.enableLogin == false {
            return
        }
        viewModel.loginRequest()
    }
}

#Preview {
    LoginView()
}
