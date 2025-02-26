# Movies
A demo app for retrieving movie data.

## 1. Setup

There is a single SPM dependency that should resolve automatically when you open the project.

## 2. Function

Users must enter 3 characters in order for the app to retrieve data. 
Data will automatically load when typing text.
Users can swipe down to refresh.
Pagination has been implemented meaning that the app will continue to load more data as the user scrolls.

## 3. Architecture

The app follows the MVVM (Model-View-ViewModel) architecture.
The app retrieves data via the DataService which runs on the HTTPClient. URLSession has been mocked to properly test the HttpClient.
I have also broken the main view into several other widgets.
Error handling is initialized at the MoviesApp.swift file and is propugated through the app via environment objects.
Navigation paths are also initialized in MoviesApp.swift and propugated via environment objects although navigation isn't implemented at the moment.

## 4. Libraries

I've included a toast library for displaying errors. It's a simple UI library that shouldn't complicate things. I've included it mostly to demonstrate my ability to work with SPM (Swift Package Manager).
