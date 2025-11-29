
# 📱 **Lyrio – Music Lyrics Downloader (Flutter)**

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

- **Flutter 3.22+**
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

