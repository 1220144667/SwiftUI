//
//  RequestApi.swift
//  iPocket
//
//  Created by WN on 2023/11/9.
//

import Foundation

//接口协议，外部定义接口必须实现此协议
protocol RequestApi {
    //接口
    var path: String { get }
    //参数
    var params: [String: Any]? { get }
}

enum RequestMethod {
    case get
    case post
    case head
    case put
    case query
    case trace
    case patch
    case options
    case delete
    case connect
    case uploadImage([Data])
    case uploadFile([URL])
}

//请求结果
struct Response<T: Codable>: Codable {
    var code: String = "0000"
    var msg: String = ""
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "retCode"
        case msg = "retMsg"
        case data = "retData"
    }
}

//空数据
struct HPNull: Codable {}

//返回成功或失败
enum HPResult<T: Codable> {
    case success(T?)
    case failure(ResponseError)
}

//Error
enum ResponseError: Error {
    case invalidUrl//url无效
    case invalidCode//url无效
    case failure(String)//接口返回错误code,服务端下发message
    case invalidToken//token失效
    case noneNetwork//无网络code
    case parseFail(String)//数据解析失败code
    case other(Error)
    
    var message: String {
        switch self {
        case .invalidUrl:
            return "无效的URL链接"
        case .invalidCode:
            return "请求错误，请检查接口和参数"
        case .failure(let string):
            return string
        case .invalidToken:
            return "token失效"
        case .noneNetwork:
            return "貌似网络连接已断开哦~~"
        case .parseFail(let msg):
            return "数据解析失败:\n\(msg)"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    static func map(_ error: Error) -> ResponseError {
      return (error as? ResponseError) ?? .other(error)
    }
}
