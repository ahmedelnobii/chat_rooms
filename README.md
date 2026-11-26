# 💬 Rooms (Chat Club)

A real-time group chat application built with **Flutter** and **Firebase**, featuring room-based conversations, live member presence tracking, private rooms with password protection, room search, invite deep links, profile & account management, and a favorites system.

---

## 📱 Screens Overview

| Splash | Home | Search | Chat | Create Room | Profile & Update |
|--------|------|--------|------|-------------|------------------|
| Session check & light-locked native splash | Browse rooms sorted by online members | Firestore name search | Real-time messaging & live members sheet | Public or private rooms | Re-auth, edit name/password & delete account |

---

## ✨ Features

### 🔐 Authentication & Splash
- **Email & Password** sign-up and login with form validation
- **Google Sign-In** (OAuth2) via `google_sign_in`
- **Session persistence** — the splash screen checks if a Firebase session is active and routes returning users straight to Home
- **Light-mode Native Splash** — configured via `flutter_native_splash` (`color` & `color_dark: "#ffffff"`) so the launch screen stays clean white even when the device OS is in Dark Mode
- **Portrait-only lock** — locked to portrait mode across Flutter (`SystemChrome`), Android (`AndroidManifest.xml`), and iOS (`Info.plist`)

### 🏠 Home — Room Browser
- Tabbed layout: **All Rooms** and **My Rooms** with a pinned tab bar inside `NestedScrollView`
- **Dynamic sorting by online members** — `All Rooms` are sorted in real time by active online members count (`members.length` descending), then by creation date (`createdAt` descending)
- **Shimmer loading skeletons** (`RoomCardShimmer`) while rooms are being fetched
- Room cards (`CustomRoomIcon`) display the room name, description, privacy lock icon (top-left), and a **Delete** button (top-right, visible only to the room creator)
- **Instant room header preview** — tapping **Join** passes the `RoomModel` via route `extra` so the chat app bar renders the room title and description immediately without waiting for Firestore

### 🔍 Search Rooms (`lib/features/search`)
- Dedicated **Search Rooms** screen accessible from the Home app bar
- Queries Firestore directly by room name prefix (`.where('roomName', isGreaterThanOrEqualTo: ...).where('roomName', isLessThanOrEqualTo: ...)`) using `.get()` to minimize Firestore reads
- Triggered explicitly when the user taps the **search icon** in the field or the **Search action key** on the keyboard (`TextInputAction.search`)
- **Clear (`×`) button** appears automatically when text is entered, clearing both the text controller and the displayed search results
- Results are sorted by **online members count** descending, then **creation date (`createdAt`)** descending

### 🔒 Private Rooms
- Rooms can be created with a password requirement
- Attempting to join a private room opens a styled **`RoomPasswordDialog`**
- **Inline error feedback** — wrong or empty password errors animate smoothly inside the dialog under the text field with a red border

### 💬 Chat Screen & Live Member Presence
- **Real-time messaging** powered by Cloud Firestore streams (`snapshots(includeMetadataChanges: true)`)
- **Chat bubbles** with sender vs. receiver styling, optimistic pending/sent status icon (`Icons.schedule` / `Icons.done`), **formatted local date & time** (`MM/DD/YYYY • hh:mm AM/PM`) underneath, and **long-press to copy** message content with haptic feedback
- **Live online member tracking**:
  - Entering a room records the user in `allRooms/{roomID}.members.{uid}` and updates `membersCount` atomically via a Firestore transaction
  - Leaving the room via the back button, swipe-back gesture (`PopScope` / `dispose()`), or backgrounding/closing the app (`AppLifecycleListener`) automatically removes the user from active members
- **Active members counter & Room Info Bottom Sheet**:
  - The app bar displays a green online dot and live member count right below the room description
  - Tapping the app bar title opens **`RoomInfoBottomSheet`**, displaying the room's full description, privacy badge, **Created by** section (with online status), and a live **In this room now** member list
- **Lively interactive buttons** (`LivelyActionButton` & `LivelySendButton`) with spring scale animations and haptic feedback
- **Optimized keyboard performance** — only `ChatInputBar` listens to `MediaQuery.viewInsetsOf(context).bottom`, preventing full-screen rebuilds during keyboard animations

### 🗑️ Delete Room
- Available to the **room creator only** (from both the `ChatAppBar` and the room card in `HomeScreen`)
- Shows a styled confirmation dialog (**`DeleteRoomDialog`**)
- Deletes all messages in `roomChat`, removes the room from `userLikes` (plus automatic stale-like cleanup in `LikedFirestoreDataSource`), and deletes the room document from `allRooms`

### ❤️ Liked Rooms
- Like / unlike any room from the chat app bar with an elastic heart animation
- **`LikedCubit` is provided at `MainScreen` (`ShellRoute`) level**, loading once per session and staying in sync via real-time snapshots so switching to the **Liked** tab is instant without re-loading
- Displays a lock icon in the trailing row for private liked rooms
- Automatically cleans up any liked room that was deleted by its creator

### 🔗 Room Invite Links
- Share any room via native share sheet (`share_plus`) with deep link: `https://<firebase-project>.web.app/room/<roomID>`
- Opening an invite link displays the branded **"You're Invited!"** landing screen with a loading state until session check and room fetch complete, then forwards the loaded `RoomModel` directly to `ChatScreen`

### 👤 Profile & Update Profile (`lib/features/update_profile`)
- **`ProfileCubit` is provided at `MainScreen` level** so profile data loads once per session
- Displays user avatar initial, name, email, and user ID with a **one-tap Copy ID** button
- **Edit Profile with Identity Verification (`ReauthDialog`)**:
  - Automatically detects the user's sign-in provider (`google.com` vs. `password`)
  - **Google users**: re-authenticates via **Continue with Google** and allows updating the **Display Name**
  - **Email/Password users**: re-authenticates with Email & Password (with inline error display inside the dialog) and allows updating both **Display Name** and **New Password**
- **Cascading name update**: updating the display name updates `users/{uid}`, Firebase Auth `displayName`, `AuthCubit.currentUser`, all **old messages** (`messageSenderName`), **created rooms** (`roomCreatorName`), and active room `members` maps in Firestore batches
- **Delete Account**: permanent account deletion in a dedicated Danger Zone card with confirmation dialog (`DeleteAccountDialog`), removing all rooms created by the user, active presence entries, liked rooms, user document, and the Firebase Auth account

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a **feature-first** folder structure and decoupled presentation widgets:

```
lib/
├── core/
│   ├── consts/          # AppColors, AppIcons, AppImages, FirebaseKeys
│   ├── di/              # Dependency injection (get_it + injectable)
│   ├── errors/          # Failure model (Failer)
│   ├── helpers/         # Form validators, field types
│   ├── models/          # Shared RoomModel & RoomMemberModel
│   ├── routes/          # GoRouter configuration & route names
│   └── widgets/         # Shared widgets (CustomButton, CustomRoomIcon,
│                        # RoomCardShimmer, DeleteRoomDialog)
│
└── features/
    ├── auth/            # Login, register, Google Sign-In, session check
    ├── chat/            # Real-time messaging, live presence, room info sheet
    ├── create_room/     # Public & private room creation form
    ├── home/            # Room browser, tabs, password verification dialog
    ├── liked/           # Liked rooms stream & toggle logic
    ├── main/            # Shell scaffold, bottom nav, ProfileCubit & LikedCubit
    ├── profile/         # User profile display & ID copy
    ├── search/          # Firestore prefix room search & sorted results grid
    ├── splash/          # Session gate & initial routing
    └── update_profile/  # Re-auth dialog, name/password update, delete account
```

### State Management & Error Handling

| Layer | Pattern / Tool |
|-------|----------------|
| State management | `flutter_bloc` (Cubit) |
| Dependency injection | `get_it` + `injectable` |
| Navigation | `go_router` (`ShellRoute` for bottom navigation synced with `matchedLocation`) |
| Error handling | Unified `Either<Failer, T>` (`dartz`) across all repositories |
| Serialization | Self-contained `fromJson` / `toJson` inside `RoomModel`, `UserModel`, and `MessageModel` |

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` / `firebase_auth` | Firebase initialization & authentication |
| `cloud_firestore` | Real-time database & presence transactions |
| `google_sign_in` | OAuth2 Google authentication |
| `flutter_bloc` | Cubit state management |
| `get_it` + `injectable` | Service locator & code-generated DI |
| `go_router` | Declarative routing & deep links |
| `dartz` | Functional error handling (`Either`) |
| `shimmer` | Loading skeleton animations |
| `flutter_animate` | List entry animations |
| `flutter_screenutil` | Responsive sizing (`375×812` design size) |
| `share_plus` | Native share sheet for room invite links |
| `google_fonts` | Custom typography |
| `flutter_native_splash` | Native launch screen (light & dark mode) |
| `flutter_launcher_icons` | Adaptive Android & iOS app launcher icons |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.12.2`
- A Firebase project with **Authentication**, **Cloud Firestore**, and **Hosting** enabled

### Setup

```bash
# 1. Clone the repository
git clone <repo-url>
cd chat_rooms

# 2. Install dependencies
flutter pub get

# 3. Run code generation (DI)
dart run build_runner build --delete-conflicting-outputs

# 4. Run static analysis & tests
flutter analyze
flutter test

# 5. Launch the app
flutter run
```
