//
//  HexColor.swift
//  SwiftUIRegistration
//
//  Created by WN on 2023/11/3.
//

import SwiftUI

extension Color {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Color {
        return Color(red: red/255.0, green: green/255.0, blue: blue/255.0)
    }
    
    static func Hex(_ hex: UInt) -> Color {
        let r = CGFloat((hex & 0xFF0000) >> 16)
        let g = CGFloat((hex & 0x00FF00) >> 8)
        let b = CGFloat(hex & 0x0000FF)
        return self.rgb(r, g, b)
    }
}
