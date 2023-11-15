//
//  RequestTarget.swift
//  iDine
//
//  Created by WN on 2023/10/18.
//

import Foundation
import Alamofire
import Moya
import UIKit

enum RequestMothod {
    case GET
    case POST
    case PUT
    case DELETE
}

//接口协议，外部定义接口必须实现此协议
protocol RequestApi {
    //接口
    var path: String { get }
    //参数
    var params: [String: Any]? { get }
}

//网络请求协议
protocol NetworkTarget: TargetType {
    var headers: [String : String]? { get }
}

extension NetworkTarget {
    var baseURL: URL {
        URL.init(string: NetworkManager.shared.environment.baseURL)!
    }
    
    var headers: [String : String]? {
        var headers = NetworkManager.shared.httpHeader()
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
    
    enum Method {
        case get
        case post
        case put
        case delete
        case uploadFiles([URL])
        case uploadFileDatas(([Data]))
    }
    
    var headers: [String : String]?
    
    //请求方式
    private let requestMethod: Method
    //请求参数
    private let parameters: [String : Any]?
    //编码方式
    var bodyEncoding: ParameterEncoding = JSONEncoding.default
    
    //初始化
    init(_ method: Method, _ api: RequestApi, _ encoding: ParameterEncoding) {
        self.requestMethod = method
        self.path = api.path
        self.parameters = api.params
        self.bodyEncoding = encoding
    }
    
    var method: Moya.Method {
        var method: Moya.Method
        switch requestMethod {
        case .get:
            method = .get
        case .post:
            method = .post
        case .put:
            method = .put
        case .delete:
            method = .delete
        case .uploadFiles, .uploadFileDatas:
            method = .post
        }
        return method
    }
    
    var task: Task {
        var task: Task
        var param = NetworkManager.shared.parameters()
        //遍历字典
        for (key, value) in self.parameters ?? [:] {
            param[key] = value
        }
        switch requestMethod {
        case .get:
            task = .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .post, .put, .delete:
            task = .requestParameters(parameters: param, encoding: bodyEncoding)
        case .uploadFiles(let files):
            let datas: [Moya.MultipartFormBodyPart] = files.map { url in
                MultipartFormBodyPart(provider: .file(url),
                                      name: "file",
                                      fileName: "pictrue.png",
                                      mimeType: "image/jpg/png/jpeg/gif")
            }
            task = .uploadCompositeMultipart(datas, urlParameters: param)
        case .uploadFileDatas(let datas):
            let datas: [Moya.MultipartFormBodyPart] = datas.map { data in
                MultipartFormBodyPart(provider: .data(data),
                                      name: "file",
                                      fileName: "pictrue.png",
                                      mimeType: "image/jpg/png/jpeg/gif")
            }
            task = .uploadCompositeMultipart(datas, urlParameters: param)
        }
        return task
    }
}

//构造请求类
extension RequestTarget {
    /// 构造get请求
    /// - Parameters:
    ///   - path: 接口
    ///   - query: 参数
    /// - Returns: 请求类
    static func get(_ path: RequestApi) -> Self {
        return Self.init(.get, path, URLEncoding.queryString)
    }
    
    /// 构造post请求
    /// - Parameters:
    ///   - path: 接口
    ///   - body: 参数
    /// - Returns: 请求类
    static func post(_ path: RequestApi, _ encoding: ParameterEncoding = JSONEncoding.default) -> Self {
        return Self.init(.post, path, encoding)
    }
    
    /// 构造put请求
    /// - Parameters:
    ///   - path: 接口
    ///   - body: 参数
    /// - Returns: 请求类
    static func put(_ path: RequestApi, _ encoding: ParameterEncoding = JSONEncoding.default) -> Self {
        Self.init(.put, path, encoding)
    }
    
    /// 构造delete请求
    /// - Parameters:
    ///   - path: 接口
    ///   - body: 参数
    /// - Returns: 请求类
    static func delete(_ path: RequestApi, _ encoding: ParameterEncoding = JSONEncoding.default) -> Self {
        Self.init(.delete, path, encoding)
    }
    
    /// 构造图片上传请求（单张图片）
    /// - Parameters:
    ///   - path: 接口
    ///   - image: 图片
    /// - Returns: 请求类
    static func upload(_ path: RequestApi, _ images: [UIImage]) -> Self {
        var datas: [Data] = []
        for image in images {
            let data = image.jpegData(compressionQuality: 0.1)!
            datas.append(data)
        }
        let upload = Method.uploadFileDatas(datas)
        return Self.init(upload, path, JSONEncoding.default)
    }
    
    /// 构造图片上传请求（多张图片URL）
    /// - Parameters:
    ///   - path: 接口
    ///   - files: 文件url列表
    /// - Returns: 请求类
    static func uploadFiles(_ path: RequestApi, _ files: [URL]) -> Self {
        let uploadFileURLs = Method.uploadFiles(files)
        return Self.init(uploadFileURLs, path, JSONEncoding.default)
    }
}

//发送请求
extension RequestTarget {
    
}
