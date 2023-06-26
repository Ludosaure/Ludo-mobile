import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/model/user_firebase.dart';

class FirebaseDatabaseUtils {
  static List<String> initConversationMemberIds(
    String targetUserId,
    List<UserFirebase> admins,
  ) {
    List<String> members = admins.map((admin) => admin.uid).toList();
    members.add(targetUserId);
    return members;
  }

  static List<Conversation> sortConversationsByRecentMessageTime(
    List<Conversation> conversations,
  ) {
    List<Conversation> sortedList =
        List.from(conversations);
    sortedList
        .sort((a, b) => b.recentMessageTime.compareTo(a.recentMessageTime));
    return sortedList;
  }
}
