🌿 Planto — Smart Plant Reminder App
Purpose:
Planto is an iOS app built with SwiftUI that helps users take care of their plants.
The main goal is to make plant care easier by reminding users when to water their plants and allowing them to track their progress through a simple, friendly interface.

<!-- Uploading "Image 07-05-1447 AH at 10.17 AM.png"... -->
Functionality:
Users can add new plants with details such as name, room, light type, watering frequency, and water amount.
The app displays a daily list of all plants. When a plant is watered, it moves to the lower part of the list with a slightly dimmed color.
A progress bar shows how many plants have been watered today.
Users can edit or delete plants anytime.
Local notifications remind users to water plants based on the selected frequency.
The app uses MVVM architecture for clean code and easy updates.

How It Works:
Add your plant and set watering details.
The app will send reminders according to your chosen frequency.
Tap the check icon to mark a plant as watered — it will move below and appear dimmed.
When all plants are watered, an “All Done” screen appears.

Planto is a mobile app built in Swift using SwiftUI.
It helps users take care of their plants by creating watering reminders and tracking daily progress.

## ⚙️ Technologies Used
- Swift 5 — main programming language  
- SwiftUI — for the user interface  
- Combine — for reactive state management  
- MVVM — app architecture pattern  
- UserNotifications — for local reminders
