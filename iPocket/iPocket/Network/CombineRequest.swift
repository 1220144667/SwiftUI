//
//  CombineRequest.swift
//  iPocket
//
//  Created by WN on 2023/11/14.
//

import Foundation
import Combine
import CombineMoya

extension RequestTarget {
    /// 请求
    /// - Parameter type: 泛型
    /// - Returns: 返回发布者
    @discardableResult func send<T: Codable>(_ type: T.Type) -> AnyPublisher<T?, ResponseError> {
        return NetworkHandle.shared.send(target: self, type: type)
    }
}

extension NetworkHandle {
    /// 网络请求
    /// - Parameters:
    ///   - target: target
    ///   - type: 泛型
    /// - Returns: 发布者
    @discardableResult func send<T: Codable>(target: RequestTarget, type: T.Type = HPNull.self) -> AnyPublisher<T?, ResponseError> {
        //无网络
        if NetworkHandle.isNetworkConnect {
            return Fail(error: ResponseError.noneNetwork)
                .eraseToAnyPublisher()
        }
        // url无效
        if target.path.isEmpty {
            return Fail(error: ResponseError.invalidUrl)
                .eraseToAnyPublisher()
        }
        let publisher = self.provider.requestPublisher(target, callbackQueue: DispatchQueue.main)
            .tryMap({ urlResponse -> Data in
                guard let res = urlResponse.response, res.statusCode == 200 else {
                  throw ResponseError.invalidCode
                }
                #if DEBUG
                let dictionary = try JSONSerialization.jsonObject(with: urlResponse.data, options: .fragmentsAllowed)
                print(dictionary)
                #endif
                return urlResponse.data
            })
            .decode(type: Response<T>.self, decoder: JSONDecoder())
            .mapError { ResponseError.parseFail($0.localizedDescription) }
            .tryMap({ result in
                switch result.code {
                case NetworkHandle.Result.success://成功
                    return result.data
                case NetworkHandle.Result.invalidToken://token已过期
                    throw ResponseError.invalidToken
                default://其他
                    throw ResponseError.failure(result.msg)
                }
            })
            .mapError { ResponseError.map($0) }
            .eraseToAnyPublisher()
        return publisher
    }
}
