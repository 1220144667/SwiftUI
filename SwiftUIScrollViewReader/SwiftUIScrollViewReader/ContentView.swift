//
//  ContentView.swift
//  SwiftUIScrollViewReader
//
//  Created by WN on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    
    //管理类
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity, maximum: .infinity))], content: {
                    ForEach(viewModel.sampleModels) { photo in
                        Image(photo.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 150)
                            .cornerRadius(8)
                            .onTapGesture {
                                viewModel.addModel(photo)
                            }
                    }
                })
            }
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem()], content: {
                        ForEach(viewModel.selectedPhotos) { photo in
                            Image(photo.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 100)
                                .cornerRadius(8)
                                .id(photo.id)
                                .onTapGesture {
                                    viewModel.removeModel(photo)
                                }
                        }
                    })
                }
                .frame(height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: viewModel.selectedPhotoId, perform: { value in
                    scrollProxy.scrollTo(value)
                })
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
