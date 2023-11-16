//
//  MaskView.swift
//  PublishingView
//
//  Created by WN on 2023/11/16.
//

import SwiftUI

struct MaskView: View {
    
    @Binding var showMaskView: Bool
    
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(0.2)
        .onTapGesture {
            self.showMaskView = false
        }
    }
}

struct SlideOutMenu: View {
    
    @Binding var showMaskView: Bool
    
    @State private var offsetY = CGSize.zero
    
    @State var isAllowToDrag = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                //下拉条
                Rectangle()
                    .foregroundStyle(Color(.systemGray4))
                    .cornerRadius(30)
                    .frame(width: 50, height: 5)
                Spacer()
                //操作按钮
                HStack(spacing: 20) {
                    operateButtonView(image: "magazine.fill", text: "写文章")
                    operateButtonView(image: "doc.plaintext.fill", text: "发沸点")
                    operateButtonView(image: "book.fill", text: "提问题")
                    operateButtonView(image: "paperplane.fill", text: "传资源")
                }
                Spacer()
                //关闭按钮
                closeButtonView()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 320)
            .background(.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: isAllowToDrag ? offsetY.height : 0)
            .gesture(DragGesture().onChanged({ gesture in
                if gesture.translation.height > 0 {
                    self.isAllowToDrag = true
                    self.offsetY = gesture.translation
                }
            }).onEnded({ _ in
                if self.offsetY.height > 100 {
                    self.showMaskView = false
                } else {
                    self.offsetY = .zero
                }
            }))
            }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func operateButtonView(image: String, text: String) -> some View {
        Button(action: {
            self.showMaskView = false
        }, label: {
            VStack(spacing: 15) {
                Image(systemName: image)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Text(text)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
            }
        })
    }
    
    func closeButtonView() -> some View {
        Button(action: {
            self.showMaskView = false
        }, label: {
            Image(systemName: "xmark")
                .font(.system(size: 24))
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
        })
    }
}
