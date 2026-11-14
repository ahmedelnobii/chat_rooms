# Chat Rooms

## Private rooms

Private room creation and password checks use Firebase callable functions.
Passwords are hashed with scrypt on the server and stored in the `roomSecrets`
collection, which is not readable by clients. Successful password checks add
the signed-in user to the room's server-managed membership list. Firestore rules
allow room chat access only to members of private rooms.

Before using room creation or private-room joining, install and deploy the
backend and rules to the Firebase project configured for the app:

```sh
cd functions
npm install
cd ..
firebase deploy --project <firebase-project-id> --only functions,firestore:rules
```

The Flutter app requires a signed-in Firebase user to use rooms.

## Sharing rooms

The chat screen shares a room link in the form
`https://<firebase-project-id>.web.app/room/<room-id>`. GoRouter resolves the
room before joining; private rooms still require their password. Firebase
Hosting rewrites room URLs to the Flutter web entry point so browser navigation
keeps the same route.

Build the web app before deploying Hosting:

```sh
flutter build web
firebase deploy --project <firebase-project-id> --only hosting
```

The default Hosting domain must be enabled for the Firebase project. To use
the browser fallback, register a Firebase web app and wire the generated
`DefaultFirebaseOptions.currentPlatform` into `Firebase.initializeApp` in
`main.dart` before building. Opening shared links directly in the installed
native app also requires Android App Links and iOS Universal Links to be
associated with the Hosting domain and the app's signing/team IDs.
