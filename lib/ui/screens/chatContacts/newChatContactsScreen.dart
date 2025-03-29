import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/chatUsersCubit.dart';
import 'package:yocut/data/models/chatUser.dart';
import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/ui/screens/chat/chatScreen.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class NewChatContactsScreen extends StatefulWidget {
  const NewChatContactsScreen({super.key});

  static Widget routeInstance() {
    // final args = Get.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (_) => ChatUsersCubit(),
      child: NewChatContactsScreen(),
    );
  }

  static Map<String, dynamic> buildArguments() {
    return {};
  }

  @override
  State<NewChatContactsScreen> createState() => _NewChatContactsScreenState();
}

class _NewChatContactsScreenState extends State<NewChatContactsScreen> {
  final _scrollController = ScrollController();
  Student? currentStudent;

  //Used to hold the children of a particular parent in case of parent login
  List<Student>? children;

  bool isStudent = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    //Initializing this at initState as the authState would never change while a login session is running
    final authState = context.read<AuthCubit>().state as Authenticated;
    if (authState.isStudent) {
      currentStudent = authState.student;
    } else {
      children = authState.parent.children;
      currentStudent = children?.firstOrNull;
      isStudent = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (context.read<ChatUsersCubit>().hasMore) {
        context.read<ChatUsersCubit>().fetchMoreChatUsers(
            role: ChatUserRole.teacher, studentId: '${currentStudent?.id}');
      }
    }
  }

  Widget _fetchChatUsers() {
    context.read<ChatUsersCubit>().fetchChatUsers(
        role: ChatUserRole.teacher, childId: '${currentStudent?.id}');
    return SizedBox.shrink();
  }

  Widget _buildStudentFilterDropdown() {
    if (isStudent) {
      return SizedBox.shrink();
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
            color: Utils.getColorScheme(context).primary, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Student>(
          isExpanded: true,
          dropdownColor: Utils.getColorScheme(context).surface,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          value: currentStudent,
          items: children
              ?.map((student) =>
                  DropdownMenuItem(child: Text('$student'), value: student))
              .toList(),
          onChanged: (value) {
            if (value != currentStudent) {
              setState(() {
                currentStudent = value;
              });
              _fetchChatUsers();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        Get.back<bool>(result: false);
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: Utils.screenContentHorizontalPadding,
                        right: Utils.screenContentHorizontalPadding,
                        top: Utils.getScrollViewTopPadding(
                            context: context,
                            appBarHeightPercentage:
                                Utils.appBarSmallerHeightPercentage)),
                    child: _buildStudentFilterDropdown()),
                BlocBuilder<ChatUsersCubit, ChatUsersState>(
                    builder: (context, state) {
                  return switch (state.status) {
                    ChatUsersFetchStatus.initial => _fetchChatUsers(),
                    ChatUsersFetchStatus.loading => Expanded(
                        child: Center(
                          child: CustomCircularProgressIndicator(
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ChatUsersFetchStatus.success => state.hasUsers
                        ? Flexible(
                            child: ListView(
                                padding: EdgeInsets.only(
                                    left: Utils.screenContentHorizontalPadding,
                                    right: Utils.screenContentHorizontalPadding,
                                    bottom:
                                        Utils.screenContentHorizontalPadding *
                                            2.5,
                                    top: 12),
                                controller: _scrollController,
                                children: state.chatUsersResponse!.chatUsers
                                    .map((user) => _buildChatUserContact(user))
                                    .toList()),
                          )
                        : NoDataContainer(titleKey: noTeachersFoundKey),
                    ChatUsersFetchStatus.failure => Center(
                        child: ErrorContainer(
                          errorMessageCode: state.errorMessage!,
                          onTapRetry: _fetchChatUsers,
                        ),
                      ),
                  };
                }),
              ],
            ),

            ///
            CustomAppBar(
              title: Utils.getTranslatedLabel("contacts"),
              onPressBackButton: () {
                Get.back<bool>(result: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatUserContact(ChatUser chatUser) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.chat,
          arguments: ChatScreen.buildArguments(
            receiverId: chatUser.id,
            image: chatUser.image,
            appbarSubtitle:
                chatUser.subjectTeachers.firstOrNull?.subjectWithName ?? "",
            teacherName: chatUser.fullName,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        margin: EdgeInsets.zero,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border(
            top: BorderSide.none,
            left: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
            ),
          ),
        ),
        child: Row(
          children: [
            /// User profile image
            Container(
              width: 48,
              height: 48,
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
                  imageUrl: chatUser.image,
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                ),
              ),
            ),
            const SizedBox(width: 16),

            ///
            Expanded(
              child: Text(
                chatUser.fullName,
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
