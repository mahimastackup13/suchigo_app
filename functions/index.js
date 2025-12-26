/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();


const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",
    pass: "qffn pwaw kehy aqnc", // Use App Password, not regular password
  },
});

// 1. Function to Send OTP
exports.sendEmailOTP = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  // Store OTP in Firestore under a temporary collection
  await admin.firestore().collection("otp_codes").doc(email).set({
    code: otp,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const mailOptions = {
    from: "Your App <your-email@gmail.com>",
    to: email,
    subject: "Your Verification Code",
    text: `Your 6-digit verification code is: ${otp}`,
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

// 2. Function to Verify OTP
exports.verifyEmailOTP = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const userCode = data.code;

  const doc = await admin.firestore().collection("otp_codes").doc(email).get();
  if (!doc.exists) throw new functions.https.HttpsError("not-found", "No OTP found");

  const { code, createdAt } = doc.data();
  
  // Check if code matches (You can also add a 5-minute expiry check here)
  if (code === userCode) {
    // Generate a Custom Auth Token for the Flutter app to sign in
    const customToken = await admin.auth().createCustomToken(email);
    await admin.firestore().collection("otp_codes").doc(email).delete();
    return { token: customToken };
  } else {
    throw new functions.https.HttpsError("invalid-argument", "Invalid OTP");
  }
});