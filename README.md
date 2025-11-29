
---

# 🎵 **Lyrio – Descarga letras sincronizadas (.lrc) para tu música**

### *Un LRCGET moderno para Android, hecho en Flutter*

[![Flutter](https://img.shields.io/badge/Flutter-3.35+-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-green?logo=android)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)]()

**Lyrio** escanea tu biblioteca musical, obtiene metadata real de los archivos de audio y descarga automáticamente letras sincronizadas (.lrc) usando **LRCLIB**.

Rápido. Simple. Open Source.

---

## 🔥 **Características principales**

* 📁 Selector de carpetas compatible con **Android 11+** (SAF)
* 🔍 Escaneo inteligente de música (`mp3`, `flac`, `m4a`, `wav`)
* 🧠 Lee metadata **real** con `metadata_god`
* 🎵 Descarga **automática** de letras sincronizadas desde LRCLIB
* 📥 **Descargar todas las letras con un solo clic**
* 💾 Guarda la carpeta seleccionada automáticamente
* ⏳ Progreso en tiempo real durante descarga masiva
* 📂 Los `.lrc` se guardan junto a la canción
* 🎨 Interfaz minimalista y rápida

---

## 🛠 **Tecnologías utilizadas**

| Tecnología             | Descripción                 |
| ---------------------- | --------------------------- |
| **Flutter 3.35+**      | Framework principal         |
| **metadata_god**       | Lectura de ID3/FLAC/M4A/WAV |
| **file_picker**        | Selección de carpetas       |
| **permission_handler** | Manejo de permisos Android  |
| **shared_preferences** | Configuración persistente   |
| **http**               | API de LRCLIB               |
| **path_provider**      | Rutas internas              |

---

## 📥 **Instalación**

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

## 📱 **Permisos Android requeridos**

`android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28"/>
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
```

✔ Compatible con Android 10–14
✔ Usa SAF, por lo que funciona incluso con restricciones modernas

---

## 🌐 **API utilizada: LRCLIB**

Se utiliza la API pública de LRCLIB:

```
https://lrclib.net/api/get?artist_name=ARTIST&track_name=TITLE&album_name=ALBUM_NAME&duration=DURATION
```

Campos importantes:

* `syncedLyrics` → letra con timestamps (para .lrc)
* `plainLyrics` → letra sin sincronizar

---

## 📂 **Estructura del proyecto**

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

## 🚀 **Cómo usar Lyrio**

1. Abre la app
2. Pulsa **“Seleccionar carpeta”**
3. Elige tu carpeta de música
4. Escanea tus archivos de audio
5. Obtén metadata real
6. Descarga letras:

   * Individualmente
   * **O todas con un clic**
7. Los archivos `.lrc` se guardan automáticamente junto a cada canción

---

## 🧭 **Roadmap**

* 🎨 Rediseño completo estilo Musixmatch
* 🎵 Mostrar carátula del álbum
* ⚡ Cache de metadata
* 🔁 Actualización automática de letras
* ✏️ Editor de `.lrc` integrado
* ☁️ Integración con Drive / Dropbox

---

## 🤝 **Contribuciones**

¡Las contribuciones son bienvenidas!
Puedes abrir Issues o Pull Requests en GitHub.

---

## 📜 **Licencia**

Distribuido bajo licencia **MIT**.
Libre para usar, modificar y compartir.

---
