//
//  Plant.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

/// نموذج البيانات الأساسي لكل نبتة في التطبيق
struct Plant: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var isWatered: Bool
    
    // تهيئة مع قيم افتراضية
    init(id: UUID = UUID(),
         name: String,
         room: String,
         light: String,
         wateringDays: String = "Every day",
         waterAmount: String,
         isWatered: Bool = false) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.wateringDays = wateringDays
        self.waterAmount = waterAmount
        self.isWatered = isWatered
    }
}
