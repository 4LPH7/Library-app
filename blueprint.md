# Project Blueprint

## Overview

A Flutter application that allows users to search for books via the Open Library API, view book details, and maintain a personal library with "Reading" and "Read" lists. The app features a dynamic theme and is structured for scalability.

## Style and Design

*   **Theme:** Modern and clean, with support for both light and dark modes.
*   **Typography:** Utilizes Google Fonts (Oswald, Roboto, Open Sans) for a clean and readable text hierarchy.
*   **Color Scheme:** A primary color palette based on deep purple, with harmonious colors generated for both light and dark themes.
*   **Layout:** A responsive and intuitive layout using a bottom navigation bar for primary navigation between the Home (search) and Library screens. Book lists are displayed in a grid view for easy browsing.
*   **Interactivity:** Interactive elements like buttons and list items have clear feedback. Book details are presented in a dedicated screen with a parallax effect for the book cover.

## Features Implemented

*   **Book Search:** Users can search for books by title, author, or keyword using a search bar on the home screen. Results are fetched from the Open Library API.
*   **Book Details:** Tapping on a book displays a dedicated screen with more information, including the cover image, author, publication date, and description. A `Hero` animation provides a smooth transition.
*   **Personal Library:**
    *   Users can add books from the details view to their personal "Reading" or "Read" lists.
    *   If a book is added to the "Read" list, it is automatically removed from the "Reading" list.
    *   The Library screen displays two sections: "Reading" and "Read".
    *   Users can remove books from either list via a confirmation dialog.
*   **Theme Toggle:** A button in the app bar allows users to instantly switch between light and dark themes.
*   **State Management:** The application uses the `provider` package to manage the state for the theme (`ThemeProvider`) and the user's library (`LibraryProvider`).
*   **Code Structure:** The project is organized with a clear separation of concerns, including folders for screens, widgets, providers, services, and models.

## Next Steps

*   **Persistence:** Implement a mechanism (like `shared_preferences` or a local database) to save the user's library, so their lists are not lost when the app is closed.
*   **UI/UX Enhancements:**
    *   Improve the visual design of the Library screen for a more engaging user experience.
    *   Add animations and transitions for smoother navigation and interactions.
    *   Provide better visual feedback when a book is added to the library.
*   **Firebase Integration:**
    *   Introduce Firebase Authentication to allow users to sign in and have their library synced across devices.
    *   Use Firestore to store the user's library data in the cloud.
*   **Advanced Error Handling:** Implement more user-friendly and specific error messages, for instance, when the network is unavailable or the API returns no results.
*   **Testing:** Write comprehensive unit and widget tests to ensure the application's logic and UI components are working correctly.
