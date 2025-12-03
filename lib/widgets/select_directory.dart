import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SelectDirectory extends StatelessWidget {
  const SelectDirectory({super.key});

  static String? selectedPath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0D1B2A),
      title: const Text(
        'Seleccionar Carpeta de Música',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Por favor, selecciona la carpeta donde se encuentra tu música para continuar.',
        textAlign: TextAlign.justify,
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.black87,
          ),
          onPressed: () {
            //falta integrarlo con el scaneo de archivos
            FilePicker.platform.getDirectoryPath().then((selectedPath) {
              Navigator.of(context).pop(selectedPath);
            });
          },
          child: const Text(
            'Seleccionar Carpeta',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
