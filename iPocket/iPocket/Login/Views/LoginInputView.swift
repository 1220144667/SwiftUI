//
//  LoginInputView.swift
//  ZMarket
//
//  Created by WN on 2023/9/23.
//

import SwiftUI

struct LoginInputView: View {
    
    @Binding var phone: String
    
    @Binding var code: String
    
    @Binding var remaining: String
    
    var sendAction: (() -> Void)?
    
    var phonePrompt = Text("请输入手机号")
        .foregroundColor(.rgb(151, 151, 151))
        .font(.system(size: 17))
    
    var codePrompt = Text("请输入验证码")
        .foregroundColor(.secondary)
        .font(.system(size: 17))
    
    var body: some View {
        VStack() {
            VStack {
                Spacer()
                HStack(spacing: 24) {
                    Image(.loginPhone)
                    TextField("", text: $phone, prompt: phonePrompt)
                    .frame(height: 31)
                    .keyboardType(.numberPad)
                }
                Divider()
            }
            .frame(height: 68)
            VStack {
                Spacer()
                HStack(spacing: 24) {
                    Image(.loginCode)
                    TextField("", text: $code, prompt: codePrompt)
                    .frame(height: 31)
                    .keyboardType(.numberPad)
                    Button(action: {
                        sendAction?()
                    }, label: {
                        Text(remaining)
                            .font(.system(size: 13))
                            .foregroundColor(.theme)
                    })
                    .frame(width: 90, height: 28)
                    .overlay() {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.theme, lineWidth: 1.0)
                    }
                }
                Divider()
            }
            .frame(height: 68)
        }
        .padding(EdgeInsets(top: 0, leading: 42, bottom: 0, trailing: 42))
    }
}

