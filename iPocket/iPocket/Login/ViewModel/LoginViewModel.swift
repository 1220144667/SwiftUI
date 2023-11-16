//
//  LoginViewModel.swift
//  iPocket
//
//  Created by WN on 2023/11/10.
//

import Foundation
import Combine
import AlertToast
import CommonCrypto
import Moya

class LoginViewModel: ObservableObject {
    //是否展示toas弹窗
    @Published var isShowToast = false
    //弹窗提示文字
    @Published var toastMessage = ""
    
    //手机号
    @Published var mobile = ""
    //手机号是否有效
    @Published var mobileValid = false
    
    //验证码
    @Published var code = ""
    //验证码是否有效
    @Published var codeValid = false
    //发送验证码是否可点击
    @Published var codeButtonEnable = true
    //验证码倒计时(默认60秒)
    @Published var remaining = "获取验证码"
    //是否已发送验证码
    @Published var isSend = false
    
    //图片验证码
    @Published var imageTitle = ""
    @Published var images: [CaptchaImageModel] = []
    //是否展示图片验证码弹窗
    @Published var isShowImageView = false
    
    //是否同意协议
    @Published var agree = false
    
    //是否可登录
    @Published var enableLogin = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        //手机号是否合法
        $mobile
            .receive(on: RunLoop.main)
            .map { $0.count == 11 }
            .assign(to: \.mobileValid, on: self)
            .store(in: &cancellableSet)
        //判断验证码是否合法
        $code
            .receive(on: RunLoop.main)
            .map { $0.count == 6 }
            .assign(to: \.codeValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest4($mobileValid, $codeValid, $isSend, $agree)
            .receive(on: RunLoop.main)
            .map { $0 && $1 && $2 && $3}
            .assign(to: \.enableLogin, on: self)
            .store(in: &cancellableSet)
    }
    
    //获取图片列表
    func queryRuleImageList() {
        if mobileValid == false {
            self.toastMessage = "请输入正确的手机号"
            self.isShowToast = true
            return
        }
        RequestTarget.query(path: LoginApi.imageRuleList(self.mobile)).send(CaptchaModel.self)
            .receive(on: RunLoop.main)
            .sink { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    self.toastMessage = error.message
                    self.isShowToast = true
                    break
                }
            } receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.imageTitle = model?.title ?? ""
                self.images = model?.smImgList ?? []
                self.isShowImageView = true
            }
            .store(in: &cancellableSet)
    }
    
    //发送验证码
    func sendSmsCode(_ val: String?) {
        self.isShowImageView = false
        guard let number = val else { return }
        RequestTarget.body(path: LoginApi.smsCode(mobile, number), encoding: URLEncoding.queryString).send(String.self)
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    self.toastMessage = error.message
                    self.isShowToast = true
                    break
                }
            } receiveValue: { [weak self] msg in
                guard let self = self else { return }
                self.toastMessage = msg ?? "发送成功"
                self.isShowToast = true
                self.isSend = true
                //倒计时
                self.startTimer()
            }
            .store(in: &cancellableSet)
    }
    
    func startTimer() {
        var second = 60
        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { timer in
                if second > 0 {
                    second -= 1
                    self.remaining = "\(second)s"
                    self.codeButtonEnable = false
                } else {
                    self.remaining = "重新获取"
                    self.codeButtonEnable = true
                }
            }
            .store(in: &cancellableSet)
    }
    
    //登录
    func loginRequest() {
        if mobileValid == false {
            self.toastMessage = "请输入正确的手机号"
            self.isShowToast = true
            return
        }
        if codeValid == false {
            self.toastMessage = "请输入正确的验证码"
            self.isShowToast = true
            return
        }
        if isSend == false {
            self.toastMessage = "请先获取验证码"
            self.isShowToast = true
            return
        }
        if agree == false {
            self.toastMessage = "请同意《用户注册协议》和《隐私政策》"
            self.isShowToast = true
            return
        }
        RequestTarget.body(path: LoginApi.login(mobile, code)).send(MktUserInfo.self)
            .receive(on: RunLoop.main)
            .sink { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    self.toastMessage = error.message
                    self.isShowToast = true
                    break
                }
            } receiveValue: { info in
                let mobile = info?.mobile ?? ""
                print(mobile)
            }
            .store(in: &cancellableSet)
    }
}
