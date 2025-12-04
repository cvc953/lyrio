import 'package:flutter/material.dart';
import '../services/notifications_settings.dart';

class ToggleNotifications extends StatefulWidget {
  const ToggleNotifications({super.key});

  @override
  State<ToggleNotifications> createState() => _ToggleNotificationsState();
}

class _ToggleNotificationsState extends State<ToggleNotifications> {
  bool toggle = true;

  @override
  void initState() {
    super.initState();
    toggleNotifications();
  }

  void toggleNotifications() async {
    toggle = await NotificationSettings.isEnabled();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF0D1B2A),
      title: toggle == true
          ? Text(
              'Habilitar notificaciones',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          : Text(
              'Deshabilitar notificaciones',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
      content: toggle == true
          ? Text(
              '¿Desea habilitar las notificaciones para letras de canciones y actualizaciones?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          : Text(
              '¿Desea deshabilitar las notificaciones para letras de canciones y actualizaciones?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
      actions: [
        TextButton(
          onPressed: () async {
            setState(() {
              toggle = !toggle;
            });
            await NotificationSettings.setEnabled(toggle);
            Navigator.of(context).pop();
          },
          child: Text('Sí', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
