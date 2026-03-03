const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

const dataPath = path.join(__dirname, "sample_data.json");
if (!fs.existsSync(dataPath)) {
  console.error("sample_data.json not found in scripts/");
  process.exit(1);
}

const data = JSON.parse(fs.readFileSync(dataPath, "utf8"));

async function main() {
  try {
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
    });

    const db = admin.firestore();

    if (!Array.isArray(data.users)) {
      throw new Error("sample_data.json must contain an array `users`");
    }

    for (const user of data.users) {
      const docId = user.id ? String(user.id) : undefined;
      if (docId) {
        await db.collection("users").doc(docId).set(user);
        console.log(`Wrote user ${docId}`);
      } else {
        const ref = await db.collection("users").add(user);
        console.log(`Added user with generated id ${ref.id}`);
      }
    }

    console.log("Seeding complete.");
    process.exit(0);
  } catch (err) {
    console.error("Error seeding Firestore:", err);
    process.exit(2);
  }
}

main();
