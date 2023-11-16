//
//  Common.swift
//  iPocket
//
//  Created by WN on 2023/11/14.
//

import Foundation
import UIKit

//打印行...
func dlog<T>(message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    if !Mkt.isDebug {
        return
    }
    var fileName = (file as NSString).lastPathComponent
    if fileName.hasSuffix(".swift") {
        fileName.removeLast(".swift".count)
    }
    print("\(fileName).\(function):\(lineNumber)\n\(message)")
}

//快捷获取主队列以及单次执行
extension DispatchQueue {
    //once
    private static var onceTokens = [String]()
    class func once(_ token: String, block: () -> Void) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        if DispatchQueue.onceTokens.contains(token) {
            return
        }
        DispatchQueue.onceTokens.append(token)
        block()
    }
    //main
    class func main(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}

public struct Mkt {
    /// app名字
    public static var appName: String {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return "村超"
    }
    /// iMarket: 返回是否是DEBUG模式
    public static var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
    }
    /// iMarket: 返回是否是真机
    public static var isDevice: Bool {
    #if targetEnvironment(simulator)
        return false
    #else
        return true
    #endif
    }
    ///获取国际化文字
    static func localized(_ name: String) -> String {
        return NSLocalizedString(name, comment: "")
    }
    /// 默认头像
    public static var defaultToAvatar: UIImage? {
        return UIImage(named: "avatar")
    }
}

//延迟函数
extension Mkt {
    /// iMarket: 延迟执行
    public static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    /// iMarket: 在x秒后运行函数
    public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
}
