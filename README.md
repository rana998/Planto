## Planto — Smart Plant Reminder App 🌱

## Purpose:
Planto is an iOS app built with SwiftUI that helps users take care of their plants.
The main goal is to make plant care easier by reminding users when to water their plants and allowing them to track their progress through a simple, friendly interface.

<img width="2236" height="1120" alt="Image" src="https://github.com/user-attachments/assets/3924255d-b965-49d3-b621-cd46190a7609" />

 ## Main Features
Add Plants: Create reminders with details like name, room, light type, watering frequency, and amount.
Daily Reminders: View all plants and mark them as watered — completed ones appear dimmed below.
Progress Tracking: A progress bar shows how many plants have been watered.
Edit & Delete: Update or remove plant reminders anytime.
Local Notifications: Get reminders based on your selected watering frequency.
All Done Screen: Celebrate when all your plants are cared for!

## ⚙️ Technologies Used
Swift 5 – Programming language
SwiftUI – User interface framework
Combine – Reactive state management
MVVM Architecture – For clean separation of logic and UI
UserNotifications – Local reminder notifications

## 🪴 How It Works
Add your plant and set watering details.
The app sends reminders according to your selected schedule.
Tap the check icon after watering — the plant moves down and becomes slightly dimmed.
When all are done, the app shows an “All Done” confirmation screen.

## Architecture
Planto follows the MVVM pattern:
Model:Defines plant data and reminder logic.
ViewModel: Manages app state, progress, and user interactions.
View: Displays reminders and handles user actions with smooth SwiftUI transitions.
