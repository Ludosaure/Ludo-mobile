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

        message.members.forEach(async (memberId: string) => {
            const receiver = await database
                .collection('users')
                .doc(memberId)
                .get();

            if(receiver.data()!.id !== message.recentMessageSender) {
                const token = receiver.data()!.token;
                messaging.sendToDevice(token, payload);
            }
        });
    });

