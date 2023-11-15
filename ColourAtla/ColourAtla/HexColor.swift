//
//  HexColor.swift
//  ColourAtla
//
//  Created by WN on 2023/10/30.
//

import Foundation
import SwiftUI

extension Color {
    //rgb
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Color {
        return Color(red: red/255.0, green: green/255.0, blue: blue/255.0)
    }
    //hex
    static func Hex(_ hex: UInt) -> Color {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16)
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8)
        let b: CGFloat = CGFloat(hex & 0x0000FF)
        return rgb(r, g, b)
    }
}
