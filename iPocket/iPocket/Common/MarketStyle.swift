//
//  MarketStyle.swift
//  ZMarket
//
//  Created by WN on 2023/9/23.
//

import Foundation
import SwiftUI

struct BigTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24))
            .foregroundColor(.init(red: 0.3, green: 0.3, blue: 0.3))
    }
}

extension Color {
    //主题色
    static var theme: Color {
        return self.rgb(0, 93, 255)
    }
    
    
    /// rgb
    /// - Parameters:
    ///   - r: 红
    ///   - g: 绿
    ///   - b: 蓝
    ///   - a: 透明度
    /// - Returns: color实例
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> Color {
        return Color.init(red: r/255.0, green: g/255.0, blue: b/255.0, opacity: a)
    }
    
    /// 十六进制颜色（0x000000）
    /// - Parameters:
    ///   - hex: （0x000000）
    ///   - a: 透明度
    /// - Returns: color实例
    static func hex(_ hex: UInt, _ a: CGFloat = 1.0) -> Color {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat(hex & 0x0000FF)
        return self.rgb(red, green, blue, a)
    }
}
