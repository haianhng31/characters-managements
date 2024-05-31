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

## Inspiration 
#### The Book Eaters by Sunyi Dean
In this novel, characters sustain themselves with books and belong to distinct families/houses, each with its own unique traits. Coexisting with us, the normap people in society, they face internal conflicts and navigate their own challenges which are usually tied to their house arrangement. As I delved into the narrative, I couldn't help but wonder about the author's logical thinking behind the story. This sparked the idea of creating an application to manage each family's members and track their real-world locations. My goal was to enhance the realism and coherence of storytelling and timelines within the narrative. 

## App Preview 
### Home page & Character Profile Page
![1](https://github.com/haianhng31/characters-managements/assets/126405175/de2a2d5f-d591-43d1-84dc-4d1bb5f4afcd)
### Create New Character Page
![2](https://github.com/haianhng31/characters-managements/assets/126405175/fcfcd534-651f-4ebf-b214-310f5847dc79)
### Map Page
![3](https://github.com/haianhng31/characters-managements/assets/126405175/61e445cb-4c7d-4426-af25-96f6ebcce9bc)


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
