
````markdown

## 📱 **Lyrio – Music Lyrics Downloader (Flutter)**

**Lyrio** es una aplicación Android construida con **Flutter** que escanea tu biblioteca musical, lee metadata real de audio (ID3/FLAC/M4A/WAV) y descarga automáticamente letras sincronizadas (`.lrc`) desde **LRCLIB**.  
Funciona como un **LRCGET para Android**, pero moderno, rápido y completamente libre.

---

## ⭐ Características

- 📁 **Selector de carpetas** (Storage Access Framework – compatible con Android 11+)  
- 🔍 **Escaneo inteligente** de música (`.mp3`, `.flac`, `.m4a`, `.wav`)  
- 🧠 **Lectura de metadata real** con `metadata_god`  
- 🎵 **Descarga de letras sincronizadas** desde **LRCLIB API**  
- 📥 **Descargar todas las letras con un solo clic**  
- 💾 **Guarda la carpeta seleccionada automáticamente**  
- 🗂 Genera archivos `.lrc` junto a cada canción  
- 🔄 Barra de progreso durante la descarga masiva  
- 📱 Interfaz simple y rápida  

---

## 🏗 Tecnologías utilizadas

- **Flutter 3.35+**
- **Dart 3.9+**
- [`metadata_god`](https://pub.dev/packages/metadata_god) – lectura de metadata  
- [`file_picker`](https://pub.dev/packages/file_picker) – selección de carpetas  
- `shared_preferences` – almacenamiento local  
- `http` – consumo de la API de LRCLIB  
- `permission_handler` – permisos Android  
- `path_provider` – rutas internas  

---

## 📥 Instalación

### 1. Clonar repositorio

```bash
git clone https://github.com/tuusuario/lyrio.git
cd lyrio
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar en Android

```bash
flutter run
```

---

## 🔧 Configuración Android

Asegúrate de incluir en `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
```

Lyrio utiliza SAF, por lo que es compatible con Android 10, 11, 12, 13 y 14.

---

## 🌐 API utilizada: LRCLIB

Lyrio utiliza la API pública de **LRCLIB**:

```
https://lrclib.net/api/get?artist=ARTIST&title=TITLE
```

Parámetros devueltos:

* `syncedLyrics` → letra sincronizada para `.lrc`
* `plainLyrics` → letra sin sincronizar

---

## 📂 Estructura del proyecto

```
lib/
 ├── main.dart
 ├── models/
 │     └── song.dart
 ├── screens/
 │     ├── home_screen.dart
 │     └── scan_screen.dart
 ├── services/
 │     ├── file_service.dart
 │     └── lrclib_service.dart
 ├── utils/
 │     ├── permissions.dart
 │     ├── folder_picker.dart
 │     └── app_storage.dart
```

---

## 🚀 Cómo usar Lyrio

1. Abre la app
2. Pulsa **“Seleccionar carpeta”**
3. Elige tu carpeta de música (Music u otra)
4. Pulsa **“Escanear”**
5. Verás una lista de canciones con metadata real
6. Puedes:

   * Descargar la letra individual
   * O pulsar **“Descargar todas las letras”** para hacerlo masivamente
7. Los archivos `.lrc` se guardan junto al archivo de audio original

---

## 🎯 Roadmap / Próximas características

* 🎨 UI estilo Musixmatch
* 🎵 Mostrar carátula del álbum
* ⚡ Cache de metadata para aperturas instantáneas
* 🔄 Actualizador automático de letras
* 👀 Editor de `.lrc` integrado
* ☁️ Integración con nubes (Drive / Dropbox)

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas.
Puedes abrir Issues o Pull Requests con mejoras o correcciones.

---

## 📜 Licencia

Este proyecto está bajo la licencia **MIT**.
Puedes usarlo, modificarlo y distribuirlo libremente.

---

