//
//  NetworkManager.swift
//  iDine
//
//  Created by WN on 2023/10/18.
//

import Foundation
import Alamofire
import Moya
import UIKit

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

//错误码
enum ResponseError: Error {
    case invalidUrl//url无效
    case invalidCode//code无效
    case noneNetwork//无网络code
    case expiredToken//token失效
    case parseFail//数据解析失败
    case failure(String)//接口返回错误code,服务端下发message
    case other(Error)//其他错误
    
    static func map(_ error: Error) -> ResponseError {
      return (error as? ResponseError) ?? .other(error)
    }
}

struct NetworkManager {
    static let shared = NetworkManager()
    
    //私有初始化，避免在外部调用
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = Constant.timeout
        let session = Session.init(configuration: configuration, startRequestsImmediately: false)
        //构造器
        self.provider = MoyaProvider<RequestTarget>(session: session, plugins: [Plugin()])
    }
    
    var provider: MoyaProvider<RequestTarget>
    
    #if DEBUG
    var environment = Environment.debug(Host.debugIP)
    #else
    var environment = Environment.release(Host.release)
    #endif
    
    struct Plugin { }
    
    /// 定义域名
    enum Host: String {
        case debugIP   = "mkt.ertix.ij0iln.top"
        case release   = "bac.new.hamkke.top"
    }
    
    private struct Constant {
        /// 协议
        static let hyperTextTransferProtocol = "http://"
        static let hyperTextTransferProtocolSecure = "https://"
                
        static let timeout: Double = 30
        
        struct HeaderFieldKey {
            static let tokenKey         = "Mkt_token_key"
            static let Authorization    = "Authorization"
            static let productVersion   = "buildNumber"
            static let versionNumber    = "versionNumber"
            static let channel          = "channel"
            static let systemVersion    = "systemVersion"
            static let lang             = "lang"
        }
        
        struct BodyKey {
            static let access_token     = "access_token"
            static let api_version      = "apiVersion"
            static let client_version   = "clientVersion"
            static let soft_type        = "softType"
        }
    }
    
    enum Environment {
        case debug(Host)
        case release(Host)
        
        var baseURL: String {
            switch self {
            case .debug(let host):
                return Constant.hyperTextTransferProtocol + host.rawValue
            case .release(let host):
                return Constant.hyperTextTransferProtocol + host.rawValue
            }
        }
        
        var host: String {
            switch self {
            case .debug(let host):
                return host.rawValue
            case .release(let host):
                return host.rawValue
            }
        }
    }
}

extension NetworkManager {
    
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
    
    func httpHeader() -> [String : String] {
        //获取token
        let authorization = ""
        let productVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let systemVersion = UIDevice.current.systemVersion
        //构造header
        var header: [String: String] = [:]
        header[Constant.HeaderFieldKey.Authorization] = authorization
        header[Constant.HeaderFieldKey.channel] = "iOS"
        header[Constant.HeaderFieldKey.productVersion] = productVersion
        header[Constant.HeaderFieldKey.versionNumber] = versionNumber
        header[Constant.HeaderFieldKey.systemVersion] = systemVersion
        return header
    }
    
    func parameters() -> [String: Any] {
        //构造携带的数据
        var param: [String: String] = [:]
        param[Constant.BodyKey.access_token] = "afe6fa65-f8c8-473f-88c6-805bf726e973"
        param[Constant.BodyKey.api_version] = "2"
        param[Constant.BodyKey.client_version] = "1.1.6"
        param[Constant.BodyKey.soft_type] = "timi_ios"
        return param
    }
}

extension NetworkManager.Plugin: PluginType {
    //打印header参数
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        // 打印请求参数
        #if DEBUG
        print("========================================")
        if let _ = request.httpBody {
            let content = "URL: \(request.url!)" + "\n" + "Method: \(request.httpMethod ?? "")" + "\n" + "Body: " + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")"
            print("\(content)")
        } else {
            let content = "URL: \(request.url!)" + "\n" + "Method: \(request.httpMethod ?? "")"
            print("\(content)")
        }
        if let headerView = request.allHTTPHeaderFields {
            print("Header: \(headerView)")
        }
        print("========================================")
        #endif
        return request
    }
}
