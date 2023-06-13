import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/conversation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

import '../../../domain/use_cases/conversations/list_conversations/list_conversations_cubit.dart';
import '../../router/routes.dart';
import 'conversations_list.dart';

class InboxPage extends StatefulWidget {
  final User user;

  const InboxPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return _getScaffold();
  }

  Widget _getScaffold() {
    if (widget.user.isAdmin()) {
      return AdminScaffold(
        body: Center(
          child: _buildConversationsList(),
        ),
        user: widget.user,
        onSearch: null,
        onSortPressed: null,
        navBarIndex: MenuItems.Messages.index,
      );
    }

    return HomeScaffold(
      body: Center(
        child: _buildConversationsList(),
      ),
      user: widget.user,
      navBarIndex: MenuItems.Messages.index,
    );
  }

  Widget _buildConversationsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocConsumer<ListConversationsCubit, ListConversationsState>(
        listener: (context, state) {
          if (state is ListConversationsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is UserMustLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ListConversationsInitial) {
            BlocProvider.of<ListConversationsCubit>(context).listConversations();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ListConversationsError) {
            return Center(
              child: const Text("no-messages-found").tr(),
            );
          }
          if (state is ListConversationsSuccess) {
            conversations = state.conversations;
            return ConversationsList(conversations: conversations);
          }
          if (state is UserMustLogError) {
            context.go(Routes.login.path);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
