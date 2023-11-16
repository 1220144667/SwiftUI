//
//  ClosureRequest.swift
//  iPocket
//
//  Created by WN on 2023/11/14.
//

import Foundation
import Moya
import RxSwift

extension RequestTarget {
    /// 请求
    /// - Parameter type: 泛型
    /// - Returns: 返回发布者
    @discardableResult func send<T: Codable>(showHUD: Bool, type: T.Type) -> Observable<HPResult<T?>> {
        return Observable.create { observable in
            let task = NetworkHandle.shared.request(self, type: type, showHUD: showHUD) { result in
                switch result {
                case .success(let model):
                    observable.onNext(.success(model))
                    observable.onCompleted()
                case .failure(let error):
                    observable.onNext(.failure(error))
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

//请求
extension NetworkHandle {
    /// 发起网络请求（成功Block回调泛型）
    /// - Parameters:
    ///   - request: 请求类
    ///   - type: 泛型
    ///   - isShow: 是否展示HUD
    ///   - successHandler: 成功回调
    ///   - failureHandler: 失败回调
    /// - Returns: 返回Task(可忽略)
    @discardableResult func request<T: Codable>(_ target: RequestTarget,
                                                type: T.Type,
                                                showHUD isShow: Bool = true,
                                                completion: @escaping (_ result: HPResult<T>) -> Void) -> Cancellable? {
        let task = self.request(target, showHUD: isShow) { data in
            if let model = self.jsonToModel(Response<T>.self, data) {
                if let error = self.filterResponseCode(model.code, message: model.msg, showHUD: isShow) {
                    completion(.failure(error))
                } else {
                    completion(.success(model.data))
                }
            } else {
                completion(.failure(.parseFail("数据解析失败！")))
            }
        } failure: { error in
            let err = ResponseError.other(error)
            completion(.failure(err))
        }
        return task
    }
    
    /// 发起网络请求（成功Block回调Data）
    /// - Parameters:
    ///   - request: 请求类
    ///   - isShow: 是否展示HUD
    ///   - success: 成功回调
    ///   - failure: 失败回调
    /// - Returns: 返回Task(可忽略)
    @discardableResult func request(_ target: RequestTarget,
                                    showHUD isShow: Bool = true,
                                    success: @escaping (_ data: Data) -> Void,
                                    failure: @escaping (_ error: Error) -> Void) -> Cancellable? {
        guard NetworkHandle.isNetworkConnect == true else {
            return nil
        }
        if isShow {
            //ProgressHUD.show("加载中...")
        }
        let task = self.provider.request(target) { result in
            switch result {
            case .success(let response):
                #if DEBUG
                guard let dictionary = self.jsonToObject(response.data) else { return }
                print(dictionary)
                #endif
                success(response.data)
            case .failure(let error):
                failure(error)
            }
        }
        return task
    }
}

extension NetworkHandle {
    //json解析为字典
    func jsonToObject(_ data: Data?) -> [String: Any]? {
        guard let data = data else { return nil }
        var dictionary: [String: Any]?
        do {
            dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
        return dictionary
    }
    //JSON解析为模型
    func jsonToModel<T: Codable>(_ modelType: T.Type, _ response: Data) -> T? {
        var modelObject: T?
        do {
            let jsonDecoder = JSONDecoder()
            modelObject = try jsonDecoder.decode(modelType, from: response)
        } catch {
            dlog(message: error)
        }
        return modelObject
    }
    /// 网络请求错误处理
    /// - Parameters:
    ///   - code: 错误码
    ///   - message: 错误提示
    ///   - isShow: 是否展示Toast
    /// - Returns: 返回错误信息
    func filterResponseCode(_ code: String, message: String, showHUD isShow: Bool = true) -> ResponseError? {
        switch code {
        case NetworkHandle.Result.success://成功
            return nil
        case NetworkHandle.Result.invalidToken://token已过期
//            let title = "提醒"
//            let message = "授权已过期，请重新登录"
//            let alert = AlertController(title: title, message: message)
//            let style = AlertVisualStyle(alertStyle: .alert)
//            style.preferredTextColor = .themColor
//            alert.visualStyle = style
//            alert.addAction(AlertAction(title: "取消", style: .normal))
//            alert.addAction(AlertAction(title: "去登录", style: .preferred, handler: { action in
//                Mkt.APP.pushLoginViewController()
//            }))
//            alert.present()
            return .invalidToken
        default://这里判断是否需要弹出toast提示框
            if isShow {
                DispatchQueue.main {
                    //Mkt.makeToast(message)
                }
            }
            return .failure(message)
        }
    }
}
