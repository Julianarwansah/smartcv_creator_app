# SmartCV Creator App 🎯

Aplikasi pembuat CV otomatis dengan AI analisis skill, template PDF profesional, dan penyimpanan cloud menggunakan Flutter + Firebase + AI.

## ✨ Fitur Utama

### 1. 🤖 AI Powered (Pollinations.ai)
- **Professional Summary**: Membuat ringkasan diri yang menarik secara otomatis.
- **Experience Formatter**: Mengubah deskripsi pekerjaan menjadi bullet points yang profesional.
- **Skill Analysis**: Menganalisis kelebihan (Strengths) dan kekurangan (Weaknesses) serta memberikan saran perbaikan.
- **Portfolio Summary**: Menghasilkan deskripsi singkat untuk project portfolio.

### 2. 📄 Multi-Template PDF Generator
Tersedia 3 pilihan template utama:
- **Minimalist**: Desain bersih dan sederhana, fokus pada konten.
- **Professional**: Tampilan korporat dengan header formal dan pemisah yang jelas.
- **Creative**: Layout modern dengan sidebar gelap untuk menonjolkan profil visual.
- *(Experimental)*: ATS-Friendly & Dark Elegant (Fallback ke template standar).

### 3. 📝 Comprehensive Resume Builder
- **Data Lengkap**: Informasi Pribadi, Pendidikan, Pengalaman, Skill, Bahasa, dan Sertifikat.
- **Real-time Preview**: Lihat perubahan CV anda sebelum di-generate.
- **Auto-Formatting**: Tanggal dan layout diatur otomatis.

### 4. ☁️ Cloud Sync & Storage
- Terintegrasi penuh dengan **Firebase Firestore**.
- Riwayat CV tersimpan aman di cloud, bisa diakses dan diedit dari perangkat mana saja.
- Manajemen file PDF yang dihasilkan.

---

## 🚀 Tech Stack

- **Frontend**: Flutter 3.9+
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **AI Engine**: Pollinations.ai (Keyless AI Proxy for OpenAI/Mistral)
- **PDF Engine**: `pdf` & `printing` packages
- **State Management**: Provider

---

## 📋 Prerequisites

- Flutter SDK 3.9.2 atau lebih baru
- Firebase Account
- Koneksi Internet (untuk AI & Firebase)

---

## 🔧 Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/Julianarwansah/smartcv_creator_app.git
cd smartcv_creator_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration
1. Buka [Firebase Console](https://console.firebase.google.com).
2. Buat project baru.
3. Tambahkan aplikasi Android dengan package name: `com.example.smartcv_creator_app`.
4. Download `google-services.json` dan letakkan di folder:
   `android/app/google-services.json`
5. Aktifkan layanan berikut di Firebase Console:
   - **Authentication**: Enable Email/Password provider.
   - **Firestore Database**: Create database (Start in test mode).
   - **Storage**: Enable storage (Start in test mode).

### 4. AI Configuration
Aplikasi ini menggunakan **Pollinations.ai** yang bersifat **gratis dan tanpa API Key** untuk keperluan development/testing. Anda tidak perlu melakukan konfigurasi API Key manual.

### 5. Run Application
```bash
flutter run
```

---

## 📱 Project Structure

```
lib/
├── models/              # Data Models (Resume, User, AI Analysis)
├── services/
│   ├── ai_service.dart  # Integrasi Pollinations.ai
│   ├── pdf_service.dart # Generator PDF (pw.Document)
│   ├── firebase_*.dart  # Layanan Firebase
│   └── ...
├── providers/           # State Management (Auth, Resume Provider)
├── screens/
│   ├── auth/            # Login/Register
│   ├── resume/          # Form Input & Preview
│   └── ...
├── widgets/             # Reusable UI Components
└── main.dart            # App Entry Point
```

---

## 🎨 Features Roadmap

### Phase 1 - Foundation ✅
- [x] Form Input Data Lengkap
- [x] Firebase Authentication (Login/Register)
- [x] Firestore CRUD (Simpan & Edit CV)
- [x] State Management Base

### Phase 2 - Intelligence & Core Features ✅
- [x] AI Professional Summary Generator
- [x] AI Skill & Weakness Analysis
- [x] Generate PDF (Minimalist, Professional, Creative)
- [x] Experience Text Formatter

### Phase 3 - Polish & Advanced 🚧
- [ ] Portfolio Builder (Partial)
- [ ] Dark Mode UI Support
- [ ] Share & Export Options (Direct WhatsApp/Email)
- [ ] Custom Color Themes for PDF

---

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License
This project is licensed under the MIT License.

## 👨‍💻 Author
**Julian Arwansah**
- GitHub: [@Julianarwansah](https://github.com/Julianarwansah)

---
Made with ❤️ using Flutter