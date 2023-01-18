import 'package:ical/serializer.dart';
import 'package:precision_hub/utils/email_utils.dart';
import 'package:precision_hub/widgets/in_app_notifications/local_notification_service.dart';

Future<void> afterAppointment(String userFullname, DateTime date, DateTime time, String doctorName, String uniqueZoomUrl, String password,
    String phone, String code, String dateString) async {
  ICalendar invite = ICalendar();
  LocalNotificationService service = LocalNotificationService();

  await invite.addElement(
    IEvent(
        alarm: IAlarm.audio(
          duration: const Duration(minutes: 2),
          repeat: 1,
          trigger: DateTime(date.year, date.month, date.day, time.hour, time.minute - 10),
        ),
        status: IEventStatus.CONFIRMED,
        description: 'Appointment with $doctorName,password for zoom: $password',
        summary: 'Appointment with $doctorName',
        start: DateTime(date.year, date.month, date.day, time.hour, time.minute),
        end: DateTime(date.year, date.month, date.day, time.hour + 1, time.minute),
        organizer: IOrganizer(name: 'Priyanka'),
        location: uniqueZoomUrl),
  );

  await downloadFile(invite.serialize(), "$dateString.ics", phone);
  sendEmail(doctorName, userFullname, dateString, phone, code, dateString, uniqueZoomUrl, password);
  service.showScheduledNotification(
      id: 0,
      title: 'Appointment',
      body: 'You have an appoinment with $doctorName in an hour',
      date: DateTime(date.year, date.month, date.day, time.hour - 1, time.minute),
      seconds: 4,
      doctoranme: "priyanka");
}
