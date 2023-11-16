//
//  LoginProtocolView.swift
//  ZMarket
//
//  Created by WN on 2023/9/23.
//

import SwiftUI

struct LoginProtocolView: View {
    
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.isSelected.toggle()
            }, label: {
                Image(isSelected ? .loginXySel : .loginXyDef)
                Text("登录即视为同意")
                    .font(.system(size: 13))
                    .foregroundColor(.black)
            })
            .frame(width: 114, height: 32)
            .padding(0)
            Button(action: {
                
            }, label: {
                Text("《注册协议》")
                    .font(.system(size: 13))
                    .foregroundColor(.theme)
            })
            .padding(0)
            Text("和")
                .font(.system(size: 13))
                .foregroundColor(.black)
                .padding(0)
            Button(action: {
                
            }, label: {
                Text("《隐私协议》")
                    .font(.system(size: 13))
                    .foregroundColor(.theme)
            })
            .padding(0)
        }
    }
}
