//
//  ContentView.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PlantOnboardingView()
    }
}

struct PlantOnboardingView: View {
    // إظهار الشيت
    @State private var showSetReminder = false
    // التنقّل إلى Today بعد الحفظ
    @State private var goToToday = false
    // أول نبتة ينشئها المستخدم
    @State private var firstPlant: Plant? = nil

    // مسودات افتراضية للشيت (نفس خياراتك)
    @State private var draftName = ""
    @State private var draftRoom = "Bedroom"
    @State private var draftLight = "Full sun"
    @State private var draftWatering = "Every day"
    @State private var draftAmount = "20-50 ml"

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    HeaderView()
                    Spacer(minLength: 10)
                    ContentSection()
                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    ReminderButton {
                        // افتح شيت الإضافة
                        draftName = ""
                        draftRoom = "Bedroom"
                        draftLight = "Full sun"
                        draftWatering = "Every day"
                        draftAmount = "20-50 ml"
                        showSetReminder = true
                    }
                }
            }
            // رابط تنقّل خفي إلى TodayReminderView بعد الحفظ
            .background(
                NavigationLink("", isActive: $goToToday) {
                    TodayReminderView(initialPlants: firstPlant.map { [$0] } ?? [])
                        .preferredColorScheme(.dark)
                }
                .opacity(0)
            )
        }
        // شيت الإضافة (نفس شكلك، فقط أضفنا onSave منطق)
        .sheet(isPresented: $showSetReminder) {
            SetReminderView(
                showSheet: $showSetReminder,
                onSave: { name, room, light, watering, amount in
                    firstPlant = Plant(
                        name: name,
                        room: room,
                        light: light,
                        wateringDays: watering,
                        waterAmount: amount,
                        isWatered: false
                    )
                    showSetReminder = false
                    goToToday = true
                }
            )
            .preferredColorScheme(.dark)
            .presentationDetents([.fraction(0.99)])
            .presentationCornerRadius(28)
            .presentationDragIndicator(.visible)
        }

    }
}

// MARK: - Header / Content / Button كما هي لديك

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("My Plants")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                Text("🌱").font(.system(size: 28))
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)

            Rectangle()
                .fill(Color.white.opacity(0.20))
                .frame(height: 1)
                .padding(.top, 12)
                .padding(.horizontal, 24)
        }
    }
}

struct ContentSection: View {
    var body: some View {
        VStack(spacing: 18) {
            Image("plant_image")
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 210)
                .clipped()
                .padding(.top, 30)

            Text("Start your plant journey!")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .frame(width: 315)
        }
        .padding(.bottom, 70)
    }
}

struct ReminderButton: View {
    var onTap: () -> Void = {}
    var body: some View {
        Button(action: onTap) {
            Text("Set Plant Reminder")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 280, height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.34, green: 0.82, blue: 0.54),
                            Color(red: 0.22, green: 0.79, blue: 0.54)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        }
        .glassEffect(.clear)
        .padding(.bottom, 100)
    }
}

#Preview { ContentView() }

