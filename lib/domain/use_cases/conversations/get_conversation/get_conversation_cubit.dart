import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/messages_repository.dart';
import 'package:ludo_mobile/domain/models/conversation.dart';
import 'package:meta/meta.dart';

part 'get_conversation_state.dart';

@injectable
class GetConversationCubit extends Cubit<GetConversationState> {
  final MessagesRepository _messagesRepository;

  GetConversationCubit(
    this._messagesRepository,
  ) : super(GetConversationInitial());

  void getConversation(String userId) async {
    emit(GetConversationLoading());
    try {
      final Conversation conversation = await _messagesRepository.getConversationByUserId(userId);
      emit(GetConversationSuccess(conversation: conversation));
    } catch (exception) {
      emit(
        GetConversationError(message: exception.toString()),
      );
    }
  }

  dispose() {
    super.close();
  }
}
