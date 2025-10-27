import SwiftUI

struct TodayReminderView: View {
    @StateObject private var vm: TodayReminderViewModel
    @AppStorage("hasOnboarded_v2") private var hasOnboarded = false

    init(initialPlants: [Plant] = []) {
        _vm = StateObject(wrappedValue: TodayReminderViewModel(initialPlants: initialPlants))
    }

    var body: some View {
        ZStack {
            APP_BG.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView()

                if !hasOnboarded {
                    OnboardingSection {
                        vm.beginAdd()
                    }
                } else {
                    if vm.allDone {
                        AllDoneView()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.25), value: vm.allDone)
                    } else {
                        progressHeader()
                        listSection()
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if hasOnboarded {
                addButton()
            }
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
                    hasOnboarded = true
                    
                    // ✅ جدولة إشعار للنبتة الجديدة
                    PlantNotification.shared.send(plant: name, every: watering)
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
                    
                    // ✅ جدولة إشعار جديد بعد التعديل
                    PlantNotification.shared.send(plant: name, every: watering)
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
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - UI

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
                // ✅ ترتيب: النباتات بدون ✓ فوق، المكتملة تحت
                ForEach(Array(vm.plants.sorted { !$0.isWatered && $1.isWatered }.enumerated()), id: \.element.id) { _, plant in
                    if let index = vm.plants.firstIndex(where: { $0.id == plant.id }) {
                        plantRow(plant, index: index)
                            .listRowBackground(APP_BG)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    vm.deleteOne(at: index)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
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
                    .foregroundStyle(plant.isWatered ? APP_GREEN.opacity(0.85) : .white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 6) {
                // المكان
                HStack(spacing: 6) {
                    Image(systemName: "location")
                        .font(.system(size: 11, weight: .semibold))
                    Text("in \(plant.room)")
                }
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(plant.isWatered ? 0.35 : 0.55))

                // اسم النبتة
                Button {
                    vm.beginEdit(index: index)
                } label: {
                    Text(plant.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white.opacity(plant.isWatered ? 0.6 : 1.0))
                }
                .buttonStyle(.plain)

                // البادجز
                HStack(spacing: 8) {
                    badge(icon: "sun.max", text: plant.light, tint: APP_YELLOW.opacity(plant.isWatered ? 0.5 : 1))
                    badge(icon: "drop",    text: plant.waterAmount, tint: APP_BLUE.opacity(plant.isWatered ? 0.5 : 1))
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
        Button { vm.beginAdd() } label: {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 54, height: 54)
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
                .overlay(Circle().stroke(.white.opacity(0.20), lineWidth: 1))
                .shadow(color: .black.opacity(0.20), radius: 8, x: 0, y: 6)
        }
        .glassEffect()
        .padding(.trailing, 20)
        .padding(.bottom, 28)
    }
}

private struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 22) {
            Image("Done_image")
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
        .padding(.top, 80)
        .navigationBarBackButtonHidden(true)
    }
}

private struct OnboardingSection: View {
    var onTapAdd: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 10)

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

            Spacer()

            Button(action: onTapAdd) {
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
}

#Preview {
    TodayReminderView()
}
