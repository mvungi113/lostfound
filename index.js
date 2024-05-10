const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNewMessageNotification = functions.firestore
  .document("chat_rooms/{chatRoomId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    const messageData = snap.data();
    const receiverID = messageData.receiverID;
    const senderEmail = messageData.senderEmail;
    const messageText = messageData.message;

    const userDoc = await admin.firestore().collection("Users").doc(receiverID).get();
    const fcmTokens = userDoc.data()?.fcmTokens || [];

    if (fcmTokens.length === 0) {
      console.log("No FCM tokens for user", receiverID);
      return;
    }

    const payload = {
      notification: {
        title: `New message from ${senderEmail}`,
        body: messageText,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    await admin.messaging().sendToDevice(fcmTokens, payload);
  });
