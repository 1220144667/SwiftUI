//
//  RequestTarget.swift
//  iPocket
//
//  Created by WN on 2023/11/7.
//

import Foundation
import UIKit
import Moya
import Combine

//网络请求协议
protocol NetworkTarget: TargetType {
    var headers: [String : String]? { get }
}

extension NetworkTarget {
    var baseURL: URL {
        URL.init(string: NetworkHandle.shared.environment.baseURL)!
    }
    
    var headers: [String : String]? {
        var headers = NetworkHandle.shared.httpHeader()
        if let tempHeaders = self.headers {
            headers.merge(tempHeaders) { _, value in
                return value
            }
        }
        return headers
    }
}

struct RequestTarget: NetworkTarget {
    
    var path: String
    
    var headers: [String : String]?
    
    //编码方式
    private var bodyEncoding: ParameterEncoding = JSONEncoding.default
    
    //请求方式
    private let requestMethod: RequestMethod
    
    //请求参数
    private let parameters: [String : Any]?
    
    //初始化
    init(_ method: RequestMethod, _ api: RequestApi, _ encoding: ParameterEncoding) {
        self.requestMethod = method
        self.path = api.path
        self.parameters = api.params
        self.bodyEncoding = encoding
    }
    
    var method: Moya.Method {
        switch requestMethod {
        case .get:
            return .get
        case .post:
            return .post
        case .head:
            return .head
        case .put:
            return .put
        case .query:
            return .query
        case .trace:
            return .trace
        case .patch:
            return .patch
        case .options:
            return .options
        case .delete:
            return .delete
        case .connect:
            return .connect
        default:
            return .post
        }
    }
    
    var task: Task {
        //请求参数
        var params = NetworkHandle.shared.parameters()
        if let tempParams = self.parameters {
            params.merge(tempParams) { _, value in
                return value
            }
        }
        var task: Task
        switch requestMethod {
        case .get:
            task = .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .uploadFile(let files):
            let items = files.map { MultipartFormData(provider: .file($0), name: "file") }
            task = .uploadCompositeMultipart(items, urlParameters: params)
        case .uploadImage(let datas):
            let items = datas.map { MultipartFormData(provider: .data($0), name: "file") }
            task = .uploadCompositeMultipart(items, urlParameters: params)
        default:
            task = .requestParameters(parameters: params, encoding: bodyEncoding)
        }
        return task
    }
}

//构造请求类
//基于项目考虑，我们关心的类型 1、请求的接口和参数， 2、请求方式 3、编码方式
extension RequestTarget {
    
    /// 构造请求参数
    /// - Parameters:
    ///   - path: 请求路径
    ///   - method: method
    ///   - encoding: 编码方式
    /// - Returns: 返回请求构造类
    static func query(path: RequestApi, method: RequestMethod = .get, encoding: ParameterEncoding = URLEncoding.queryString) -> Self {
        return Self.init(method, path, encoding)
    }
    
    static func body(path: RequestApi, method: RequestMethod = .post, encoding: ParameterEncoding = JSONEncoding.default) -> Self {
        return Self.init(method, path, encoding)
    }
}
