# KiGeotag

A specialized Flutter application that integrates hardware camera controls with GPS location services to create timestamped and geotagged photographic evidence.

## 📸 Overview

This application allows users to capture images that are automatically processed to include a visible text overlay of the user's current geographic coordinates. It is designed for field work, inspections, or any scenario requiring location-verified photography.

## ✨ Features

* **Real-time Camera Preview:** Accesses device hardware via the `camera` package with medium resolution presets.
* **GPS Integration:** High-accuracy location fetching using the `geolocator` package.
* **Dynamic Image Watermarking:** * Decodes raw image bytes post-capture.
    * Injects a text string containing `Lat` and `Long` directly into the image buffer using the `image` library.
    * Re-encodes the processed image back to JPG format for storage.
* **Automatic Image Versioning:** Saves the processed photo as a separate file with an `_updated.jpg` suffix to preserve the original if needed.

## 📁 Technical Architecture

### Core Dependencies
| Package | Purpose |
| :--- | :--- |
| `camera` | Hardware interface for photo capture and preview. |
| `geolocator` | Real-time fetching of device GPS coordinates. |
| `image` | Server-side style image processing (decoding, drawing text, re-encoding). |
| `path_provider` | (Implicitly required) for managing file storage paths. |

### Logic Flow
1.  **Initialize:** App requests camera permissions and starts high-accuracy location tracking simultaneously.
2.  **Capture:** User triggers the shutter; the app captures a standard `XFile`.
3.  **Process:** The app reads the file as bytes, uses the `arial_24` font to draw the location coordinates at the top-left (10,10) position.
4.  **Save:** The watermarked image is written to the device's temporary directory and the state is updated to display the result.

---

## 📁 Project Structure

```text
lib/
└── main.dart          # Contains the CameraPage State and Image Processing logic