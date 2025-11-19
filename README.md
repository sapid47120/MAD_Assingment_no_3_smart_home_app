📱 Project Overview

This Flutter application is developed as part of Assignment-3 for the Mobile Application Development course.
The goal of the app is to simulate a Smart Home Dashboard where users can monitor and control various smart devices (lights, fans, AC, cameras, etc.) inside a home environment.

The application demonstrates:

UI structuring with GridView, Rows, Columns

Navigation between screens

Stateful interactivity

Device controls (toggle, slider, buttons)

Dynamic device addition

Modern UI design using ThemeData

Responsive layout handling

✨ Features Implemented
1. Dashboard Screen

Displays smart home devices arranged using GridView.

Each device is represented through a Card widget containing:
✔ Device icon
✔ Device name
✔ Toggle switch (ON/OFF)
✔ Current status text

2. AppBar Design

Left: Menu icon

Center: Title → “Smart Home Dashboard”

Right: Profile picture

3. Device Details Screen

When a device card is tapped:

App navigates using Navigator.push()

Display includes:
✔ Large device image
✔ Current status text
✔ Slider for brightness/speed (depending on device type)
✔ Back button to return

4. Add New Device (FAB)

Pressing the FloatingActionButton opens a dialog/screen with fields:

Device name

Device type (Dropdown)

Room name

Status (default OFF)

Newly added devices appear dynamically on the dashboard.

5. Stateful Interactivity

Switch toggles

Real-time UI updates

Slider adjustments

Device status changes

6. Gesture Feedback

Device cards are wrapped with GestureDetector / InkWell

Visual interaction (color/scale change on tap)

7. Responsive UI

Uses Flexible, Expanded, MediaQuery

Works smoothly on different screen sizes

8. Consistent Theme

Custom colors (light, blue, grey)

Custom typography

Modern app styling using ThemeData

🗂 Project Structure
MAD_Assingment_no_3_smart_home_app/
 ├── lib/
 │    ├── main.dart           # Main application code
 │    └── ...                 # Additional UI and stateful logic
 ├── web/                     # Web build files
 ├── build/                   # Generated build output
 ├── test/                    # Flutter test files
 ├── pubspec.yaml             # Dependencies & assets
 ├── README.md                # Project documentation

🛠 Technologies Used

Flutter

Dart

Material Design

Stateful Widgets

Navigator API

▶ How to Run the Project

Clone the repo:

git clone <your_repo_link>


Then:

flutter pub get
flutter run

📌 Notes

This assignment demonstrates core Flutter concepts required for building modern, responsive, interactive mobile applications.
