# 🦉 CleverOwl – Task Manager iOS App

CleverOwl is an iOS app built with **Swift**, designed to help users organize their tasks in a simple and effective way.  
Each task can include:  
- ✅ Title & Description  
- 🗂️ Category  
- 📅 Due Date  
- ⭐ Priority Flag  

Tasks can be listed **grouped by category** or in a **flat list**, giving users flexibility to track what matters most.

---

## 🚀 Features
- Add, edit, and delete tasks easily  
- Group tasks by category or view all together  
- Mark tasks as important for quick identification  
- Persistent storage using **UserDefaults** (no external DB required)  
- Clean and intuitive interface following iOS design guidelines  

---

## 🛠️ Tech Stack
- **Language:** Swift  
- **Framework:** UIKit  
- **Storage:** UserDefaults  
- **Architecture:** MVC with modular organization  
- **Deployment Target:** iOS 14+  

---

## 🎯 Project Goals & Learning Outcomes
This project was built to strengthen my skills in:  
- iOS app architecture and state management  
- Data persistence without external dependencies  
- Building **user-friendly interfaces** with UIKit  
- Turning a simple idea into a functional and polished product  

---

## 📸 Demo

<p align="center">
  <img src="screenshot.gif" alt="CleverOwl Demo" width="300"/>
</p>

---

## 📂 Project Structure
```text
CleverOwl/
├── Assets.xcassets # App icons and image assets
├── Base.lproj # Storyboards and UI files
├── Bruner/Helpers # Helper classes
├── Model # Task model definition
├── TableViewCell # Custom cell for tasks
├── TableViewController # Main tasks list
├── ViewController # Task creation/management
├── AppDelegate.swift # App lifecycle
├── SceneDelegate.swift # Scene lifecycle
└── Info.plist # Project settings
```


---

## 📥 Installation & Usage
1. Clone the repo  
   ```bash
   git clone https://github.com/rodrigobruner/cleverOwl.git
   ```
2. Open CleverOwl.xcodeproj in Xcode
3. Run on Simulator or physical iOS device (iOS 14+)
