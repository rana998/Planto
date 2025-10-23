//
//  TodayReminderView.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

struct TodayReminderView: View {
    @StateObject private var vm: TodayReminderViewModel

    // تهيئة تسمح بتمرير نباتات أولية (من شاشة البداية مثلًا)
    init(initialPlants: [Plant] = []) {
        _vm = StateObject(wrappedValue: TodayReminderViewModel(initialPlants: initialPlants))
    }

    var body: some View {
        ZStack {
            APP_BG.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView()

                if vm.allDone {
                    AllDoneView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: vm.allDone)
                } else {
                    progressHeader()
                    listSection()
                }
            }

            addButton()
        }
        // شيت الإضافة
        .sheet(isPresented: $vm.showAddSheet) {
            EditReminderView(
                showSheet: $vm.showAddSheet,
                mode: .add,
                onSave: { name, room, light, watering, amount in
                    vm.draftName = name
                    vm.draftRoom = room
                    vm.draftLight = light
                    vm.draftWatering = watering
                    vm.draftAmount = amount
                    vm.saveFromDraft()
                },
                onDelete: nil,
                plantName: vm.draftName,
                room:      vm.draftRoom,
                light:     vm.draftLight,
                watering:  vm.draftWatering,
                amount:    vm.draftAmount
            )
            .preferredColorScheme(.dark)
        }
        // شيت التعديل
        .sheet(isPresented: $vm.showEditSheet) {
            EditReminderView(
                showSheet: $vm.showEditSheet,
                mode: .edit,
                onSave: { name, room, light, watering, amount in
                    vm.draftName = name
                    vm.draftRoom = room
                    vm.draftLight = light
                    vm.draftWatering = watering
                    vm.draftAmount = amount
                    vm.saveFromDraft()
                },
                onDelete: { vm.deleteEditing() },
                plantName: vm.draftName,
                room:      vm.draftRoom,
                light:     vm.draftLight,
                watering:  vm.draftWatering,
                amount:    vm.draftAmount
            )
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - UI (نفس تصميمك)

    private func headerView() -> some View {
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
                .fill(.white.opacity(0.2))
                .frame(height: 1)
                .padding(.top, 12)
                .padding(.horizontal, 24)
        }
    }

    private func progressHeader() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if vm.progress == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                customProgressBar(progress: 0)
            } else {
                let doneCount = Int(vm.progress * Double(vm.plants.count))
                Text("\(doneCount) of your plants feel loved today✨")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                customProgressBar(progress: vm.progress)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }

    private func customProgressBar(progress: Double) -> some View {
        GeometryReader { proxy in
            let barWidth = proxy.size.width * 0.85
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.15)).frame(height: 6)
                if progress > 0 {
                    Capsule()
                        .fill(APP_GREEN)
                        .frame(width: barWidth * progress, height: 6)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(width: barWidth, alignment: .leading)
            .padding(.top, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 10)
    }

    private func listSection() -> some View {
        List {
            Section(header:
                Text("Today")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            ) {
                ForEach(Array(vm.plants.enumerated()), id: \.element.id) { index, plant in
                    plantRow(plant, index: index)
                        .listRowBackground(APP_BG)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) { vm.deleteOne(at: index) } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func plantRow(_ plant: Plant, index: Int) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // دائرة التشيك
            Button { vm.toggleWatered(at: index) } label: {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(plant.isWatered ? APP_GREEN : .white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 6) {
                // المكان
                HStack(spacing: 6) {
                    Image(systemName: "location")
                        .font(.system(size: 11, weight: .semibold))
                    Text("in \(plant.room)")
                }
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.55))

                // اسم النبتة ➜ يفتح التعديل
                Button {
                    vm.beginEdit(index: index)
                } label: {
                    Text(plant.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                // البادجز
                HStack(spacing: 8) {
                    badge(icon: "sun.max", text: plant.light, tint: APP_YELLOW)
                    badge(icon: "drop",    text: plant.waterAmount, tint: APP_BLUE)
                }
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }

    private func badge(icon: String, text: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.12))
        )
    }

    private func addButton() -> some View {
        VStack { Spacer()
            HStack { Spacer()
                Button { vm.beginAdd() } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        // لو تبغي التدرّج بدل APP_GREEN عدّلي هذا السطر فقط
                        .background(
                            Circle().fill(
                                LinearGradient(
                                    colors: [Color(red: 0.34, green: 0.82, blue: 0.54),
                                             Color(red: 0.34, green: 0.82, blue: 0.54).opacity(0.9)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        )

                        .overlay(Circle().stroke(.white.opacity(0.50), lineWidth: 1))
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                }
                .glassEffect(.clear)
                .padding(.trailing, 20)
                .padding(.bottom, 28)
            }
        }
    }
}

// شاشة All Done لو كنتِ ضفتِها قبل — اتركيها كما هي
// شاشة "All Done" (تُعرض فقط عند اكتمال التشييك)
private struct AllDoneView: View {
    let imageName: String = "Done_image"

    var body: some View {
        VStack(spacing: 22) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)

            Text("All Done! 🎉")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Text("All Reminders Completed")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 40)
        .navigationBarBackButtonHidden(true) // تأكيد إضافي داخل الشاشة نفسها
    }
}



#Preview {
    TodayReminderView()
}
