//
//  LoginImagesView.swift
//  iPocket
//
//  Created by WN on 2023/11/11.
//

import SwiftUI
import Kingfisher


struct LoginImagesView: View {
    
    @Binding var imageTitle: String
    
    @Binding var images: [CaptchaImageModel]
    
    var itemAction: ((String) -> Void)?
    
    private let layout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 300)
                .foregroundStyle(Color.white)
            VStack {
                Text(imageTitle)
                LazyVGrid(columns: layout, spacing: 0, content: {
                    ForEach(images, id: \.url) { item in
                        let url = item.url ?? ""
                        KFImage(URL(string: url))
                            .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
                            .cornerRadius(6)
                            .onTapGesture {
                                itemAction?(item.val ?? "")
                            }
                    }
                })
            }
        }
        .padding()
    }
}
