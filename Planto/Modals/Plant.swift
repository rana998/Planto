//
//  Plant.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

/// نموذج البيانات الأساسي لكل نبتة في التطبيق
struct Plant: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String = "Every day"
    var waterAmount: String
    var isWatered: Bool = false
}
