//
//  EditReminderView.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

struct EditReminderView: View {
    enum Mode { case add, edit }

    @Binding var showSheet: Bool
    var mode: Mode = .edit
    var onSave: ((String, String, String, String, String) -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    // بيانات (تُمرَّر من الشاشة السابقة)
    @State var plantName: String
    @State var room: String
    @State var light: String
    @State var watering: String
    @State var amount: String

    // نفس الخيارات
    private let rooms   = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    private let lights  = ["Full sun", "Partial Sun", "Low Light"]
    private let days    = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    private let amounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]

    // ألوانك الثابتة
    private let bg   = Color(red: 0.07, green: 0.07, blue: 0.08)
    private let card = Color(red: 0.17, green: 0.17, blue: 0.18)
    private let green = Color(red: 0.34, green: 0.82, blue: 0.54)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 22) {

                // الشريط العلوي (X - العنوان - ✓)
                HStack {
                    Button { showSheet = false } label: {
                        Image(systemName: "xmark")
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.white.opacity(0.08)))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Text(mode == .add ? "Set Reminder" : "Edit Reminder")
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

                // اسم النبات
                HStack(spacing: 10) {
                    Text("Plant Name").foregroundStyle(.white)
                    Rectangle().fill(green).frame(width: 2, height: 18)
                    TextField("Enter plant name", text: $plantName)
                        .foregroundStyle(.white.opacity(0.85))
                        .accentColor(green)
                }
                .font(.system(size: 17))
                .frame(height: 59)
                .padding(.horizontal, 18)
                .background(card, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)

                // المجموعة الأولى (الغرفة + الإضاءة)
                VStack(spacing: 12) {
                    row(icon: "location", title: "Room", value: $room, options: rooms)
                    row(icon: "sun.max", title: "Light", value: $light, options: lights)
                }
                .padding(.horizontal, 20)

                // المجموعة الثانية (أيام السقي + كمية الماء)
                VStack(spacing: 12) {
                    row(icon: "drop", title: "Watering Days", value: $watering, options: days)
                    row(icon: "drop", title: "Water", value: $amount, options: amounts)
                }
                .padding(.horizontal, 20)

                // زر الحذف ➜ يظهر فقط في وضع التعديل
                if mode == .edit {
                    Button(action: {
                        onDelete?()
                        showSheet = false
                    }) {
                        Text("Delete Reminder")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.20))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    // صف عام للقوائم المنسدلة
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

// Preview
#Preview {
    EditReminderView(
        showSheet: .constant(true),
        mode: .edit,
        onSave: {_,_,_,_,_ in},
        onDelete: {},
        plantName: "Pothos",
        room: "Bedroom",
        light: "Full sun",
        watering: "Every day",
        amount: "20-50 ml"
    )
}
