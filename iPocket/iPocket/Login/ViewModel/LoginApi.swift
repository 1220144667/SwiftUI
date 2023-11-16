//
//  LoginApi.swift
//  iPocket
//
//  Created by WN on 2023/11/11.
//

import Foundation

enum LoginApi: RequestApi {
    case imageRuleList(String)
    case smsCode(String, String)
    case login(String, String)
    case cauthToken(String, String)
    
    var path: String {
        switch self {
        case .imageRuleList:
            return "/mkt/open/img/smImgRule/provList"
        case .smsCode:
            return "/mkt/login/mobile/XXXXX"
        case .login:
            return "/mkt/login/mobile/XXXXX"
        case .cauthToken:
            return "/mkt/oauth/XXXXX"
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .imageRuleList(let mobile):
            return ["mobile": mobile]
        case .smsCode(let mobile, let member):
            return ["mobile": mobile, "number": member]
        case .login(let mobile, let code):
            let phone = mobile.prefix(7)
            let random = arc4random() % 8999 + 1000
            let randomNum = "\(phone)\(random)"
            var params: [String: Any] = [:]
            params["mobile"] = mobile
            params["checkCode"] = code
            params["randomCode"] = randomNum
            params["deviceId"] = "com.zion.pocket"
            params["channelCode"] = "ios"
            params["commendType"] = "1"
            params["commendCode"] = ""
            return params
        case .cauthToken(let mobile, let code):
            return ["mobile": mobile, "number": code]
        }
    }
}
