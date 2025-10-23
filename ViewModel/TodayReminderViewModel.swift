//
//  TodayReminderViewModel.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import Combine

final class TodayReminderViewModel: ObservableObject {
    // البيانات
    @Published var plants: [Plant]

    // الشيت + التعديل
    @Published var showAddSheet = false
    @Published var showEditSheet = false
    @Published var editingIndex: Int? = nil

    // مسودات الشيت
    @Published var draftName = ""
    @Published var draftRoom = "Bedroom"
    @Published var draftLight = "Full sun"
    @Published var draftWatering = "Every day"
    @Published var draftAmount = "20-50 ml"

    // تهيئة (تسمح بتمرير نباتات ابتدائية)
    init(initialPlants: [Plant] = []) {
        self.plants = initialPlants
    }

    // التقدّم + All Done
    var progress: Double {
        guard !plants.isEmpty else { return 0 }
        let done = plants.filter { $0.isWatered }.count
        return Double(done) / Double(plants.count)
    }

    var allDone: Bool {
        !plants.isEmpty && plants.allSatisfy { $0.isWatered }
    }


    // أفعال الواجهة
    func toggleWatered(at index: Int) {
        plants[index].isWatered.toggle()
    }

    func deleteOne(at index: Int) {
        plants.remove(at: index)
    }

    func beginAdd() {
        clearIfAllDone()  // ← إضافة السطر هذا

        editingIndex = nil
        draftName = ""
        draftRoom = "Bedroom"
        draftLight = "Full sun"
        draftWatering = "Every day"
        draftAmount = "20-50 ml"
        showAddSheet = true
    }


    func beginEdit(index: Int) {
        editingIndex = index
        let p = plants[index]
        draftName = p.name
        draftRoom = p.room
        draftLight = p.light
        draftWatering = p.wateringDays
        draftAmount = p.waterAmount
        showEditSheet = true
    }

    func saveFromDraft() {
        let newItem = Plant(
            name: draftName,
            room: draftRoom,
            light: draftLight,
            wateringDays: draftWatering,
            waterAmount: draftAmount,
            isWatered: editingIndex.flatMap { plants[$0].isWatered } ?? false
        )

        if let i = editingIndex {
            plants[i] = newItem
        } else {
            plants.append(newItem)
        }
    }

    func deleteEditing() {
        if let i = editingIndex {
            plants.remove(at: i)
        }
    }
    
    // احذف كل النباتات المكتملة (عليها ✓)
    func clearCompleted() {
        plants.removeAll { $0.isWatered }
    }

    // نستخدمها فقط إذا كانت كل النباتات مكتملة (All Done)
    func clearIfAllDone() {
        if allDone { clearCompleted() }
    }

    
    
}
