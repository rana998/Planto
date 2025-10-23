//
//  Colors+Hex.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// ألوان التطبيق
let APP_GREEN  = Color(hex: "28E0A8")
let APP_YELLOW = Color(hex: "CCC785")
let APP_BLUE   = Color(hex: "CAF3FB")
let APP_BG     = Color.black
let APP_CARD   = Color(red: 0.17, green: 0.17, blue: 0.18)

