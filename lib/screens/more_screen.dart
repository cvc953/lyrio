import 'package:flutter/material.dart';
import 'package:lyrio/widgets/scan_music.dart';
import 'package:lyrio/widgets/select_directory.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Más', style: TextStyle(color: Colors.white)),
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
            leading: Icon(Icons.notifications_on, color: Colors.white),
            title: Text(
              'Notificaciones',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Acción al tocar "Biblioteca"
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
