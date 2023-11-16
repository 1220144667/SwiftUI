//
//  NotificationToastView.swift
//  NotificationToast
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct NotificationToastView: View {
    
    var notificationImage = "full-english-thumb"
    var notificationTitle = "文如秋雨"
    var notificationContent = "一只默默努力变优秀的产品汪，独立负责过多个国内细分领域Top5的企业级产品项目，擅长B端、C端产品规划、产品设计、产品研发，个人独立拥有多个软著及专利，欢迎产品、开发的同僚一起交流。"
    var notificationTime = "2分钟前"
    
    var body: some View {
        HStack {
            Image(notificationImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1))
            VStack(spacing: 10) {
                HStack {
                    Text(notificationTitle)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Text(notificationTime)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
                Text(notificationContent)
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: 80)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color(.systemGray4), radius: 5, x: 1, y: 1)
        .padding()
    }
}

#Preview {
    NotificationToastView()
}
