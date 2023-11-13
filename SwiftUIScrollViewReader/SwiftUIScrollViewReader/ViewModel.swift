//
//  ViewModel.swift
//  SwiftUIScrollViewReader
//
//  Created by WN on 2023/11/13.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    //图片名称列表
    private var images: [String] = []
    //原始图片数组
    @Published var sampleModels: [Model] = []
    //选中图片数组
    @Published var selectedPhotos: [Model] = []
    //当前选中的图片ID
    @Published var selectedPhotoId: UUID?
    
    //初始化
    init() {
        images = ["Fantasy",
                  "Horror",
                  "Kids",
                  "Mystery",
                  "Poetry",
                  "Romance",
                  "Thriller"]
        //map：数组高阶函数，返回处理完成的新数组
        sampleModels = images.map { Model(imageName: $0) }
    }
    
    //移除原始数组里的元素、添加到选中数组里面
    func addModel(_ photo: Model) {
        selectedPhotos.append(photo)
        selectedPhotoId = photo.id
        if let index = sampleModels.firstIndex(where: { $0.id == photo.id }) {
            sampleModels.remove(at: index)
        }
    }
    
    //移除选中数组里的元素、添加到原始数组里面
    func removeModel(_ photo: Model) {
        sampleModels.append(photo)
        if let index = selectedPhotos.firstIndex(where: { $0.id == photo.id }) {
            selectedPhotos.remove(at: index)
        }
    }
}
