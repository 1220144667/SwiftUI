//
//  MktUserInfo.swift
//  iPocket
//
//  Created by WN on 2023/11/11.
//

import Foundation

struct MktUserInfo: Codable {
    /**8位Des加密串*/
    var randomCode: String?
    /**用户id*/
    var userId: String?
    /**用户名*/
    var userName: String?

    var mobile: String?

    var cardId: String?

    var isFillBaseInfo: Bool?

    var authState: Bool?
}

struct CaptchaModel: Codable {
    var title: String?
    var smImgList: [CaptchaImageModel]?
}

struct CaptchaImageModel: Codable {
    var url: String?
    var val: String?
}
