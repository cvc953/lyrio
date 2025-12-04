import 'package:flutter/material.dart';
import 'package:lyrio/widgets/scan_music.dart';
import 'package:lyrio/widgets/select_directory.dart';
import '../services/notifications_settings.dart';
import '../widgets/toggleNotifications.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool notificationsEnable = true;

  @override
  void initState() {
    super.initState();
    enableNotifications();
  }

  void enableNotifications() async {
    notificationsEnable = await NotificationSettings.isEnabled();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Más',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: null,
            title: Center(
              child: Text(
                'Lyrio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Center(
              child: Text(
                'Encuentra letras sincronizadas para toda tu música',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ListTile(
            leading: notificationsEnable == false
                ? Icon(Icons.notifications_on, color: Colors.white)
                : Icon(Icons.notifications_off, color: Colors.white),
            title: Text(
              'Notificaciones',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              // Acción al tocar "Notificaciones"
              showDialog(
                context: context,
                builder: (context) => ToggleNotifications(),
              );
              await NotificationSettings.setEnabled(notificationsEnable);

              setState(() async {
                //notificationsEnable = !notificationsEnable;
                notificationsEnable = !notificationsEnable;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.sd_card, color: Colors.white),
            title: Text(
              'Almacenamiento',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Acción al tocar "Configuración"
              showDialog(
                context: context,
                builder: (context) => SelectDirectory(),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.white),
            title: Text(
              'Escanear música',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Acción al tocar "Escanear música"
              showDialog(context: context, builder: (context) => ScanMusic());
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.white),
            title: Text('Ayuda', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Acción al tocar "Ayuda"
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('Acerca de', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Acción al tocar "Acerca de"
            },
          ),
        ],
      ),
    );
  }
}
