import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/socketSettingCubit.dart';
import 'package:yocut/cubits/userChatHistoryCubit.dart';
import 'package:yocut/data/models/chatContact.dart';
import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/ui/screens/chat/chatScreen.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatContactsScreen extends StatefulWidget {
  ChatContactsScreen({Key? key}) : super(key: key);

  static Widget routeInstance() {
    // final args = Get.arguments as Map<String, dynamic>;

    return BlocProvider(
      create: (_) => UserChatHistoryCubit(),
      child: ChatContactsScreen(),
    );
  }

  static Map<String, dynamic> buildArguments() {
    return {};
  }

  @override
  State<ChatContactsScreen> createState() => _ChatContactsScreenState();
}

class _ChatContactsScreenState extends State<ChatContactsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchUserChatHistory();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (context.read<UserChatHistoryCubit>().hasMore) {
        context
            .read<UserChatHistoryCubit>()
            .fetchMoreUserChatHistory(role: ChatUserRole.teacher);
      }
    }
  }

  void _fetchUserChatHistory() {
    context
        .read<UserChatHistoryCubit>()
        .fetchUserChatHistory(role: ChatUserRole.teacher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: BlocBuilder<UserChatHistoryCubit, UserChatHistoryState>(
              builder: (context, state) {
                if (state is UserChatHistoryFetchFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: _fetchUserChatHistory,
                    ),
                  );
                }

                if (state is UserChatHistoryFetchSuccess) {
                  /// if there are no chat contacts, show a message to start a new chat
                  if (state.userChatHistory.chatContacts.isEmpty)
                    return _buildStartNewChat(context);

                  /// if there are chat contacts, show the chat contacts
                  return BlocListener<SocketSettingCubit, SocketSettingState>(
                    listener: (context, state) {
                      if (state is SocketMessageReceived) {
                        context.read<UserChatHistoryCubit>().messageReceived(
                              from: state.from,
                              message: state.message.message ?? "",
                              updatedAt:
                                  state.message.updatedAt.toIso8601String(),
                              incrementUnreadCount:
                                  Get.currentRoute == Routes.chatContacts,
                            );
                      }
                    },
                    child: ListView(
                      padding: EdgeInsets.only(
                        right: Utils.screenContentHorizontalPadding,
                        left: Utils.screenContentHorizontalPadding,
                        bottom: Utils.screenContentHorizontalPadding * 2.5,
                        top: Utils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              Utils.appBarSmallerHeightPercentage,
                        ),
                      ),
                      controller: _scrollController,
                      children: [
                        ...state.userChatHistory.chatContacts
                            .map((contact) => _buildChatContact(contact))
                            .toList(),

                        ///
                        if (state.loadMore)
                          Center(
                            child: CustomCircularProgressIndicator(
                              indicatorColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return Center(
                  child: CustomCircularProgressIndicator(
                    indicatorColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(title: chatsKey),
          ),
        ],
      ),
      floatingActionButton:
          BlocBuilder<UserChatHistoryCubit, UserChatHistoryState>(
        builder: (context, state) {
          if (state is UserChatHistoryFetchSuccess) {
            if (state.userChatHistory.chatContacts.isEmpty) {
              return const SizedBox.shrink();
            }

            return FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              onPressed: () async {
                Get.toNamed(Routes.newChatContacts)?.then((_) {
                  _fetchUserChatHistory();
                });
              },
              child: SvgPicture.asset(
                Utils.getImagePath("add_chat.svg"),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStartNewChat(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          SvgPicture.asset(
            Utils.getImagePath("new_chat_icon.svg"),
            width: 132,
            height: 132,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              Utils.getTranslatedLabel("connectWithTeachers"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              Utils.getTranslatedLabel("connectWithTeachersDesc"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomRoundedButton(
            onTap: () {
              Get.toNamed(Routes.newChatContacts)?.then((_) {
                _fetchUserChatHistory();
              });
            },
            widthPercentage: 0.5,
            height: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            buttonTitle: Utils.getTranslatedLabel("letsStartChat"),
            showBorder: false,
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildChatContact(ChatContact contact) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Get.toNamed(
            Routes.chat,
            arguments: ChatScreen.buildArguments(
              receiverId: contact.user.id,
              image: contact.user.image,
              appbarSubtitle:
                  contact.user.subjectTeachers.firstOrNull?.subjectWithName ??
                      "",
              teacherName: contact.user.fullName,
            ),
          )?.then(
            (result) {
              if (result.unreadCount > 0) {
                context
                    .read<UserChatHistoryCubit>()
                    .updateUnreadCount(contact.user.id, result.unreadCount);
              }

              if (result.lastMessage != null) {
                context.read<UserChatHistoryCubit>().updateLastMessage(
                      contact.user.id,
                      result.lastMessage,
                      result.lastMessageTime,
                    );
              }
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: colorScheme.surface,
          ),
          child: Row(
            children: [
              /// User profile image
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.tertiary,
                ),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: contact.user.image,
                    fit: BoxFit.cover,
                    width: 45,
                    height: 45,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              ///
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// User name and last message time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.user.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            Utils.hourMinutesDateFormat.format(
                              DateTime.parse(contact.updatedAt).toLocal(),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.secondary.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1.5),

                      /// Last message and unread count
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.lastMessage ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: colorScheme.secondary.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),

                          ///
                          if (contact.unreadCount > 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                color: colorScheme.onPrimary,
                              ),
                              child: Text(
                                contact.unreadCount.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
