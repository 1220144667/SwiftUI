//
//  NetworkHandle.swift
//  iPocket
//
//  Created by WN on 2023/11/7.
//

import Foundation
import Alamofire
import Moya
import CombineMoya
import Combine

struct NetworkHandle {
    
    static let shared = NetworkHandle()
    
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
        case debugIP   = "xxxx.xxxx.xx"
        case release   = "xxx.xxxxx.xx"
    }
    
    private struct Constant {
        /// 协议
        static let hyperTextTransferProtocol = "http://"
        static let hyperTextTransferProtocolSecure = "https://"
        /// 超时时间
        static let timeout: Double = 30
    }
    
    //请求头
    private struct HeaderFieldKey {
        static let tokenKey         = "Mkt_token_key"
        static let Authorization    = "Authorization"
        static let productVersion   = "buildNumber"
        static let versionNumber    = "versionNumber"
        static let channel          = "channel"
        static let systemVersion    = "systemVersion"
        static let lang             = "lang"
    }
    
    //请求体
    private struct BodyKey {
        static let access_token     = "access_token"
        static let api_version      = "apiVersion"
        static let client_version   = "clientVersion"
        static let soft_type        = "softType"
    }
    
    struct Result {
        static let success = "0000"
        static let invalidToken = "1111"
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

extension NetworkHandle {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
    
    func httpHeader() -> [String : String] {
        return [:]
    }
    
    func parameters() -> [String: Any] {
        //构造携带的数据
        var param: [String: String] = [:]
        param[BodyKey.access_token] = UserManager.token
        param[BodyKey.api_version] = "2"
        param[BodyKey.client_version] = "1.0.0"
        param[BodyKey.soft_type] = "ios"
        return param
    }
}

extension NetworkHandle.Plugin: PluginType {
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

/*
 let title = "提醒"
 let message = "授权已过期，请重新登录"
 let alert = AlertController(title: title, message: message)
 let style = AlertVisualStyle(alertStyle: .alert)
 style.preferredTextColor = .themColor
 alert.visualStyle = style
 alert.addAction(AlertAction(title: "取消", style: .normal))
 alert.addAction(AlertAction(title: "去登录", style: .preferred, handler: { action in
     Mkt.APP.pushLoginViewController()
 }))
 alert.present()
 */
