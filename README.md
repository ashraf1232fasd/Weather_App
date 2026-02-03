# ☁️ Flutter Weather App (Clean Architecture/Bloc)

A robust, production-ready Weather Application built with **Flutter**, demonstrating **Clean Architecture**, **BLoC** state management, and full **Localization**.

This project fetches real-time weather data from the [OpenWeatherMap API](https://openweathermap.org/api) and offers a seamless user experience with offline support and theme customization.

---

## ✨ Features

* **🔍 City Search:** Real-time search with a "Smart History" dropdown.
* **🌍 Full Localization:** * Supports **English** and **Arabic** (RTL).
    * Translates UI elements *and* API data (e.g., "Clear Sky" → "سماء صافية").
    * **Instant Switching:** Changes language without restarting the app.
* **🎨 Dynamic Theming:** Light and Dark modes (persisted locally).
* **📡 Offline Support:** Caches the last successful weather data for offline viewing.
* **📊 Detailed Weather:** Displays Temperature, Humidity, Wind Speed, and Min/Max temps.
* **🛡️ Error Handling:** Graceful handling of server errors, network connectivity, and empty states.

---

## 🛠️ Tech Stack & Architecture

This project strictly follows **Clean Architecture** principles to ensure separation of concerns, scalability, and testability.

* **Architecture:** Clean Architecture (Data, Domain, Presentation layers).
* **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc).
* **Dependency Injection:** [get_it](https://pub.dev/packages/get_it).
* **Networking:** [dio](https://pub.dev/packages/dio) with interceptors.
* **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences).
* **Environment Variables:** [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) (Securing API Keys).
* **Responsiveness:** [flutter_screenutil](https://pub.dev/packages/flutter_screenutil).
* **Functional Programming:** [fpdart](https://pub.dev/packages/fpdart) (For Either<Failure, Success>).

---

## 📂 Project Structure

The project follows **Clean Architecture** to ensure separation of concerns and scalability:

```text
lib/
├── core/                   # Shared utilities & core functionality
│   ├── error/              # Error handling (Failures & Exceptions)
│   ├── network/            # Network connectivity checks
│   ├── services/           # General services
│   ├── theme/              # Theme configuration (Light & Dark)
│   ├── utils/              # Constants, Strings, and Helpers
│   └── usecases/           # Base UseCase abstraction
│
├── features/
│   └── weather/            # Main Feature: Weather
│       ├── data/           # Data Layer (Implementation)
│       │   ├── datasources/# Remote (API) & Local (Cache) Data Sources
│       │   ├── models/     # Data Models (JSON Parsing / Serialization)
│       │   └── repositories/# Repository Implementation
│       │
│       ├── domain/         # Domain Layer (Business Logic & Contracts)
│       │   ├── entities/   # Core Data Objects (Pure Dart)
│       │   ├── repositories/# Repository Interfaces (Abstract Contracts)
│       │   └── usecases/   # Application Business Rules (GetWeather, etc.)
│       │
│       └── presentation/   # Presentation Layer (UI & State)
│           ├── bloc/       # State Management (BLoC)
│           ├── pages/      # UI Screens (Home, Details)
│           └── widgets/    # Reusable UI Components
│
├── l10n/                   # Localization files (.arb for EN/AR)
├── main.dart               # Application Entry Point
└── injection_container.dart # Dependency Injection Setup (GetIt)
🚀 Getting Started
1. Clone the repository
Bash
git clone [https://github.com/YOUR_USERNAME/weather_app.git](https://github.com/YOUR_USERNAME/weather_app.git)
cd weather_app
2. Install dependencies
Bash
flutter pub get
3. Setup Environment Variables (Critical ⚠️)
Create a .env file in the root directory and add your OpenWeatherMap API key:

Code snippet
API_KEY=your_open_weather_api_key_here
4. Run the app
Bash
flutter run
