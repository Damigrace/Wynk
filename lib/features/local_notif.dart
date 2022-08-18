
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  Future <void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('yellow');



    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

  }
  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
  static showNotif(String title,String message )async{

    await FlutterLocalNotificationsPlugin().show(
        12345,
        title,
        message,
        NotificationDetails(
            android: AndroidNotificationDetails(
                '1',
                'a',
                'white',
                importance: Importance.max,
                priority: Priority.max,
                visibility: NotificationVisibility.public
            )
        ),
        payload: 'data');
  }
}
