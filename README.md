# Characters Management App
This is a Flutter application for managing characters in a game or story. It allows users to create, view, and edit characters with various attributes and associated markers on a map.

## Features
* **Character Creation**: Create new characters with details such as name, vocation, and description, with the help of *AI*!
* **Character Editing**: Edit existing character details and levels of skills (such as health, attack, defense, etc).
* **Map Integration**: Plot character markers on a map and view their associated information.
* **Marker Management**: Add, edit, and remove markers for each character on the map.
* **Marker Information**: Display detailed information about each marker, including associated characters, dates, and descriptions.
* **Search Location**: Allows users to search for a specific location. When a location is entered into the search bar, the map navigates to that location.
* **Current Location Tracker**: The map updates in real-time to follow the device's movements. Additionally, users can quickly return to their current location on the map with a designated button if they have navigated to another area.

## Getting Started
To run this project locally, follow these steps:
1. Make sure you have Flutter installed and set up on your machine. You can find the installation instructions here.
2. Clone this repository:
```git clone https://github.com/haianhng31/characters-managements.git```
3. Navigate to the project directory:
```cd characters-managements```
4. Get the required packages:
```flutter pub get```
5. Run the app:
```flutter run```

## Dependencies
This project relies on the following packages:
* provider: For state management.
* google_maps_flutter: For integrating Google Maps into the Flutter app.
* dart_openai: For integrating with the OpenAI API, specifically for generating text.
* image: For image manipulation and processing.
* path_provider: For accessing system file paths.
* flutter_dotenv: For loading environment variables from a .env file.
* cupertino_icons: A set of icons for Cupertino-styled widgets.
* google_fonts: For using Google Fonts in the app.
* uuid: For generating and parsing Universally Unique Identifiers (UUIDs).
* firebase_core: The core Firebase package for integrating Firebase services.
* cloud_firestore: For integrating with Firebase Cloud Firestore, a NoSQL cloud database.
* http: For making HTTP requests.
* json_annotation: For generating code for JSON serialization and deserialization.
* json_serializable: For providing JSON serialization and deserialization.
* location: For accessing the device's location services.
* flutter_polyline_points: For calculating and rendering polylines (routes) on Google Maps.
* custom_info_window: For displaying custom information windows on Google Maps.
* intl: For internationalization and localization support.
* flutter_image: For displaying images from various sources.

## Contributing
Contributions to this project are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.
