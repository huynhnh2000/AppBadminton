import 'package:firebase_messaging/firebase_messaging.dart';

enum FCMType { foreground, background, terminated }

enum FcmMessageAction { navigation, showModal }

enum NotificationType {
  detail(0),
  openUrl(1),
  webview(2),
  gotoScreen(3),
  onAppModal(4);

  final int? value;

  const NotificationType(this.value);
}

enum NotificationScreenType {
  EXPRESS_BUY_DETAIL(1),
  EXPRESS_SELL_DETAIL(2),
  RAMP_DETAIL(3),
  BLOCKCHAIN(4);

  final int? value;

  const NotificationScreenType(this.value);
}

class FcmIncomingMessage {
  final FCMType type;
  final MessageData data;
  final FcmMessageAction action;
  // final dynamic pushToRouteName;
  // final Map<String, dynamic> arguments;
  final AndroidNotification? androidNotification;
  final RemoteNotification? notification;

  FcmIncomingMessage(
      {required this.data,
      required this.action,
      required this.type,
      this.androidNotification,
      this.notification});
}

class MessageData {
  String? oldTitle;
  String? oldContent;
  String? title;
  String? content;
  String? link;
  String? notificationItemId;
  RemoteNotification? remoteNotification;
  String? linkWeb;

  String? screen;
  String? params;
  String? variables;

  MessageData({
    this.title,
    this.content,
    this.link,
    this.remoteNotification,
    this.notificationItemId,
    this.linkWeb,
    this.screen,
    this.params,
    this.variables,
    this.oldContent,
    this.oldTitle,
  });

  MessageData.fromJson(Map<String, dynamic> data,
      {RemoteNotification? remoteNotification}) {
    oldContent = data['oldBody'] ?? remoteNotification?.title;
    oldTitle = data['oldTitle'] ?? remoteNotification?.body;
    title = data['title'] ?? remoteNotification?.title;
    content = data['message'] ?? data['body'] ?? remoteNotification?.body;
    notificationItemId = data['notify_id'];

    link = data['link'];
    remoteNotification = remoteNotification;
    linkWeb = data['link_web'];
    screen = data['screen'];
    params = data['params'] ?? '[]';
    variables = data['variables'] ?? '{}';
  }

  String get getLink => link ?? '';
}
