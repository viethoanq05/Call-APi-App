# Seed Firestore with sample data

Steps to run the seed script (writes to collection `users`):

1. Install Node.js (if not installed).
2. From project root, initialize a small npm project and install `firebase-admin`:

```bash
cd call_api_app
npm init -y
npm install firebase-admin
```

3. Create a Firebase service account key with Firestore access and download the JSON file from the Firebase Console (Project Settings -> Service accounts).

4. Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to point to the downloaded service account JSON.

Windows PowerShell (current session):

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS = 'C:\path\to\serviceAccount.json'
node scripts/seedFirestore.js
```

Windows (cmd):

```cmd
set GOOGLE_APPLICATION_CREDENTIALS=C:\path\to\serviceAccount.json
node scripts/seedFirestore.js
```

Linux / macOS:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccount.json"
node scripts/seedFirestore.js
```

5. The script will write each entry from `scripts/sample_data.json` into the `users` collection using `id` as the document id when present.

Notes:

- The script uses Application Default Credentials; you can also initialize with `admin.credential.cert(require('/path/to/key.json'))` if you prefer to embed the key path directly.
- Make sure your Firestore rules allow writes for the service account (they should by default).

Flutter app steps:

- Add Firestore package and fetch dependencies:

```bash
flutter pub get
```

- Run the app on an emulator or device. The app now reads users from the Firestore `users` collection. Use the cloud icon in the app bar to check Firebase initialization.

- If you seeded Firestore with `scripts/seedFirestore.js`, the `users` collection should already contain documents; otherwise add documents manually in the Firebase Console.
