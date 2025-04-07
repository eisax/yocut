import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/cubits/notificationsCubit.dart';
import 'package:yocut/data/repositories/notificationRepository.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider(
      create: (context) => NotificationsCubit(NotificationRepository()),
      child: NotificationsScreen(),
    );
  }

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      context.read<NotificationsCubit>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
            if (state is NotificationsFetchSuccess) {
              if (state.notifications.isEmpty) {
                return Align(
                    alignment: Alignment.center,
                    child: NoDataContainer(titleKey: noNotificationsKey));
              }
              return Align(
                alignment: Alignment.topCenter,
                child: RefreshIndicator(
                  displacement: Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarSmallerHeightPercentage),
                  onRefresh: () async {
                    context.read<NotificationsCubit>().fetchNotifications();
                  },
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                          bottom: 25,
                          left: MediaQuery.of(context).size.width *
                              (Utils
                                  .screenContentHorizontalPaddingInPercentage),
                          right: MediaQuery.of(context).size.width *
                              (Utils
                                  .screenContentHorizontalPaddingInPercentage),
                          top: Utils.getScrollViewTopPadding(
                              context: context,
                              appBarHeightPercentage:
                                  Utils.appBarSmallerHeightPercentage)),
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: MediaQuery.of(context).size.width * (0.85),
                          child: LayoutBuilder(
                            builder: (context, boxConstraints) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: boxConstraints.maxWidth *
                                        (notification.attachmentUrl.isEmpty
                                            ? 1.0
                                            : 0.725),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title,
                                          style: TextStyle(
                                            height: 1.2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          notification.body,
                                          style: TextStyle(
                                            height: 1.2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                        Text(
                                          timeago
                                              .format(notification.createdAt),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.75),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                      ],
                                    ),
                                  ),
                                  notification.attachmentUrl.isNotEmpty
                                      ? const Spacer()
                                      : const SizedBox(),
                                  notification.attachmentUrl.isNotEmpty
                                      ? Container(
                                          width:
                                              boxConstraints.maxWidth * (0.25),
                                          height:
                                              boxConstraints.maxWidth * (0.25),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          notification
                                                              .attachmentUrl)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )
                                      : const SizedBox()
                                ],
                              );
                            },
                          ),
                        );
                      }),
                ),
              );
            }
            if (state is NotificationsFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    context.read<NotificationsCubit>().fetchNotifications();
                  },
                ),
              );
            }
            return Center(
              child: CustomCircularProgressIndicator(
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(title: notificationsKey),
          ),
        ],
      ),
    );
  }
}
