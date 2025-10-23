//
//  SetReminderView.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

struct SetReminderView: View {
    // بدل Environment: نستخدم Binding بسيط جاي من الشاشة الرئيسية
    @Binding var showSheet: Bool
    var onSave: ((String, String, String, String, String) -> Void)? = nil

       @State private var plantName = ""
       @State private var room      = "Bedroom"
       @State private var light     = "Full sun"
       @State private var watering  = "Every day"
       @State private var amount    = "20-50 ml"

    // خيارات القوائم
    private let rooms   = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    private let lights  = ["Full sun", "Partial Sun", "Low Light"]
    private let days    = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    private let amounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]

    // ألوان بسيطة
    private let bg   = Color(red: 0.07, green: 0.07, blue: 0.08)
    private let card = Color(red: 0.17, green: 0.17, blue: 0.18)
    private let green = Color(red: 0.34, green: 0.82, blue: 0.54)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 22) {

                // شريط علوي: إغلاق - عنوان - حفظ
                HStack {
                    Button { showSheet = false } label: {          // ← الصيغة الصحيحة
                        Image(systemName: "xmark")
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.white.opacity(0.08)))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Text("Set Reminder")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    Button {
                        onSave?(plantName, room, light, watering, amount)
                        showSheet = false
                    } label: {
                        Image(systemName: "checkmark")
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(
                                    LinearGradient(colors: [green, green.opacity(0.9)],
                                                   startPoint: .top, endPoint: .bottom)
                                )
                            )
                            .overlay(Circle().stroke(.white.opacity(0.28), lineWidth: 0.6))
                            .foregroundStyle(.white)
                    }

                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // حقل اسم النبات
                HStack(spacing: 10) {
                    Text("Plant Name").foregroundStyle(.white)
                    Rectangle().fill(green).frame(width: 2, height: 18)
                    TextField("Pothos", text: $plantName)
                        .foregroundStyle(.white.opacity(0.85))
                        .accentColor(green)
                }
                .font(.system(size: 17))
                .frame(height: 59)
                .padding(.horizontal, 18)
                .background(card, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)

                // المجموعة الأولى
                VStack(spacing: 12) {
                    row(icon: "location", title: "Room", value: $room, options: rooms)
                    row(icon: "sun.max", title: "Light", value: $light, options: lights)
                }
                .padding(.horizontal, 20)

                // المجموعة الثانية
                VStack(spacing: 12) {
                    row(icon: "drop", title: "Watering Days", value: $watering, options: days)
                    row(icon: "drop", title: "Water", value: $amount, options: amounts)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    // صف بسيط مع Menu
    private func row(icon: String, title: String,
                     value: Binding<String>, options: [String]) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 22, height: 22)
                .foregroundStyle(.white)

            Text(title)
                .foregroundStyle(.white)

            Spacer()

            Menu {
                ForEach(options, id: \.self) { item in
                    Button(item) { value.wrappedValue = item }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(value.wrappedValue)
                        .foregroundStyle(.white.opacity(0.85))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .font(.system(size: 17))
        .frame(height: 58)
        .padding(.horizontal, 18)
        .background(card, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// Preview يحتاج Binding
#Preview {
    SetReminderView(showSheet: .constant(true))
}
