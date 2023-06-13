import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/reservation_provider.dart';
import 'package:ludo_mobile/domain/models/message.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';

import '../../domain/models/conversation.dart';
import '../providers/messages/message_provider.dart';

@injectable
class MessagesRepository {
  final MessageProvider _messageProvider;

  MessagesRepository(this._messageProvider);

  Future<List<Conversation>> getMyConversations() async {
    return await _messageProvider.getMyConversations();
  }

  Future<Conversation> getConversationByUserId(String userId) async {
    return await _messageProvider.getConversationByUserId(userId);
  }
}