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
