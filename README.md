# 🩺 SkinScan – AI-Powered Skin Cancer Detection

SkinScan is a **Flutter-based mobile application** that leverages **deep learning (ResNet50, TensorFlow Lite)** to detect potential skin cancer from images. The app aims to make **early awareness and detection accessible**, while providing prevention tips and educational resources.  

---

## ✨ Features
- 📸 **Image Input** – Capture from camera or choose from gallery  
- 🧠 **On-Device AI Model** – Runs `skincancer.tflite` locally for fast & private predictions  
- 📊 **Detailed Results** – Displays cancer category, description, and severity level  
- 🛡️ **Prevention & Awareness** – Precautionary steps and guidance for each skin cancer type  
- 🎨 **Modern UI** – Built with Flutter, bottom navigation bar, and side drawer navigation  
- 🔒 **Privacy-Friendly** – No cloud uploads; all processing happens on-device  

---

## 🛠️ Tech Stack
- **Frontend:** Flutter (Dart)  
- **AI Model:** TensorFlow Lite (ResNet50 CNN)  
- **Architecture:** MVVM with modular UI  

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)  
- Android Studio / VS Code with Flutter & Dart plugins  
- A device/emulator running Android or iOS  

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/sktabby/skin_scan_app.git
   cd skinscan
