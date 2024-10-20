# Country List App

## Overview

The Country List App is a Flutter application that displays a list of countries by fetching data from a remote API. This app allows users to search for countries, view detailed information, and sort the list based on various criteria. It incorporates state management using the BLoC pattern and provides a responsive and user-friendly interface.

## Features

- **Remote Data Fetching**: Retrieves country data from a public API.
- **Search Functionality**: Users can filter the list of countries based on their names.
- **Sorting Options**: Sort countries by relevance or alphabetical order.
- **Responsive UI**: Adapts to different screen sizes and orientations.
- **Connectivity Handling**: Displays appropriate messages based on the internet connection status.
- **Dark/Light Theme Toggle**: Users can switch between dark and light themes.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE such as Android Studio, VS Code

### Installation

1. Clone the repository:
   git clone https://github.com/manojbcs98/country_app.git

#Project Structure
lib/
├── barrel.dart          # Barrel file to simplify imports
├── main.dart            # Entry point of the application
├── models/              # Data models
│   └── country.dart     # Country model
├── cubits/              # BLoC Cubits
│   └── country_cubit.dart # Cubit for managing country state
├── services/            # API service classes
│   └── country_service.dart # Service for fetching country data
├── views/widgets             # UI Components
│   ├── country_list_view.dart # Main view displaying country list
│   └── country_tile.dart # Widget for individual country tile

#Usage
1. Search for a Country
Type in the search bar to filter the list of countries by name.

2. Sort the Country List
Use the sort dropdown to organize the countries either by relevance or alphabetically.

3.Theme Toggle
Tap the theme icon in the AppBar to switch between dark and light themes.

4. Country List View with details

