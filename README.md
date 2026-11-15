# 💬 Chat Club

A real-time group chat application built with **Flutter** and **Firebase**, featuring room-based conversations, private rooms with password protection, invite links, and a favorites system.

---

## 📱 Screenshots & Screens

| Splash | Home | Chat | Create Room |
|--------|------|------|-------------|
| Session check on launch | Browse & filter rooms | Real-time messaging | Public or private rooms |

---

## ✨ Features

### 🔐 Authentication
- **Email & Password** sign-up and login with form validation
- **Google Sign-In** (OAuth2) via `google_sign_in`
- **Session persistence** — the splash screen automatically checks if a Firebase session is still active, skipping the login screen for returning users
- Instant redirect to home on active session, or to login on session expiry

### 🏠 Home — Room Browser
- Tabbed layout: **All Rooms** and **My Rooms**
- Pinned tab bar with `NestedScrollView` for a smooth scroll experience
- **Shimmer loading skeletons** while rooms are being fetched
- Room cards show name, description, creator, and privacy status (🔒 Private / 🌐 Public)

### 🔒 Private Rooms
- Rooms can be created with a password requirement
- Attempting to join a private room shows a **password dialog** inline
- Password validation is performed before granting access

### 💬 Chat Screen
- **Real-time messaging** powered by Cloud Firestore streams
- Messages displayed with **chat bubbles** (sender vs. receiver style)
- Shimmer placeholder while messages load
- Optimised keyboard handling — only the input bar rebuilds on keyboard open/close, not the entire screen
- Error dialog with **Retry** option on message load failure
- Displays room name and description in the app bar

### ❤️ Liked Rooms
- Like / unlike any room directly from the chat screen's app bar
- All liked rooms are saved to Firestore per user
- Dedicated **Liked Rooms** tab with animated list items (`flutter_animate`)
- Toggle-like syncs instantly across the chat screen and liked screen

### 🔗 Room Invite Links
- Share any room via a deep link (`share_plus`)
- Generated link: `https://<firebase-project>.web.app/invite/<roomID>`
- Opening the invite link shows a branded **"You're Invited!"** landing screen
- Automatically checks session on arrival — redirects to login if not authenticated, then proceeds to join the room

### ➕ Create Room
- Room name, description, and optional password
- **Live form validation** (auto-validate on user interaction)
- Private room toggle — password field appears/hides dynamically
- Disables the submit button until the form is valid

### 👤 Profile
- Displays user avatar (initial letter), name, email, and user ID
- Shimmer skeleton while profile loads
- **Sign out** button — navigates back to the login screen
- Profile data loads **once** at app launch (Cubit lives at `MainScreen` level), so switching back to the profile tab never re-fetches

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a feature-first folder structure:

```
lib/
├── core/
│   ├── consts/          # Colors, icons, images, Firebase keys
│   ├── di/              # Dependency injection (get_it + injectable)
│   ├── errors/          # Failure models
│   ├── helpers/         # Validators, field types
│   ├── models/          # Shared models (RoomModel)
│   ├── routes/          # GoRouter config & route names
│   └── widgets/         # Shared widgets (CustomButton)
│
└── features/
    ├── auth/            # Login, register, Google Sign-In, session check
    ├── chat/            # Real-time messaging, room detail
    ├── create_room/     # Room creation form
    ├── home/            # Room browser, tabs, password dialog
    ├── liked/           # Liked rooms list, toggle logic
    ├── main/            # Shell scaffold, bottom nav, ProfileCubit provider
    ├── profile/         # User profile display
    └── splash/          # Session check & navigation gate
```

### State Management

| Layer | Tool |
|-------|------|
| State management | `flutter_bloc` (Cubit) |
| Dependency injection | `get_it` + `injectable` |
| Navigation | `go_router` (ShellRoute for bottom nav) |
| Error handling | `dartz` Either (Left = Failure, Right = Success) |

> [!NOTE]
> `ProfileCubit` is provided at the `MainScreen` (ShellRoute) level so the profile
> loads **once** per session — not every time the user taps the Profile tab.

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_auth` | Authentication |
| `cloud_firestore` | Real-time database |
| `cloud_functions` | Firebase Cloud Functions |
| `google_sign_in` | OAuth2 Google login |
| `flutter_bloc` | State management |
| `get_it` + `injectable` | Dependency injection |
| `go_router` | Declarative routing & deep links |
| `dartz` | Functional error handling (Either) |
| `shimmer` | Loading skeleton animations |
| `flutter_animate` | List entry animations |
| `flutter_screenutil` | Responsive layout (design size 375×812) |
| `share_plus` | Native share sheet for invite links |
| `google_fonts` | Custom typography |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.12.2`
- A Firebase project with **Authentication**, **Firestore**, and **Hosting** enabled

### Setup

```bash
# 1. Clone the repository
git clone <repo-url>
cd chat_rooms

# 2. Install dependencies
flutter pub get

# 3. Add your Firebase config files
#    - android/app/google-services.json
#    - ios/Runner/GoogleService-Info.plist

# 4. Run code generation (DI)
dart run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

---

## 📁 Project Structure Highlights

```
features/main/main_screen.dart      ← Shell with bottom nav + ProfileCubit
features/chat/presentation/
  view/chat_screen.dart             ← Real-time chat + like + share
  view/room_invite_screen.dart      ← Deep-link invite landing page
features/home/presentation/
  view/widgets/join_room.dart       ← Password dialog logic
  cubit/room_password_cubit.dart    ← Password state
core/routes/routers.dart            ← All GoRouter route definitions
```

---

## 🔮 Roadmap

- [ ] Push notifications for new messages
- [ ] Search rooms by name
- [ ] User avatars / profile pictures
- [ ] Message reactions
- [ ] Unread message count badge on nav bar
