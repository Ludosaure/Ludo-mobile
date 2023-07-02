import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

//initialize firebase
admin.initializeApp();

    //notify new messages
export const pushNotificationForNewMessage = functions.firestore.document('conversations/{conversationId}')
    .onUpdate(async snapshot => {
        const database = admin.firestore();
        const messaging = admin.messaging();
        const message = snapshot.after.data();

        const receiver = await database
            .collection('users')
            .doc(message.targetUserId)
            .get();

        const sender = await database
            .collection('users')
            .doc(message.recentMessageSender)
            .get();

        const payload = {
            notification: {
                title: 'Nouveau message de : ' + sender.data()!.firstname,
                body: message.recentMessage,
                icon: 'https://www.laludosaure.fr/Files/136017/Img/14/ludosaure-logo-min.png'
            }
        }

        const token = receiver.data()!.token;

        return messaging.sendToDevice(token, payload);
    });

