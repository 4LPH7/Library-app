# My Library Blueprint

## Overview

My Library is a Flutter application that allows users to search for books using the Open Library API, view book details, and maintain a personal library. The app features a modern, visually appealing design with a focus on user experience.

## Style, Design, and Features

### Theming and Styling

*   **Theme:** The app uses a Material 3 theme with a custom color scheme generated from a seed color. It supports both light and dark modes, with a theme toggle in the app bar.
*   **Typography:** The app uses the `google_fonts` package to apply custom fonts for a unique and readable text style.
*   **Component Styling:** The app bar and other components are styled to match the overall theme, creating a consistent look and feel.

### Application Architecture

*   **State Management:** The app uses the `provider` package for state management, with a `ThemeProvider` to manage the app's theme.
*   **Services:** An `ApiService` class encapsulates all interactions with the Open Library API, including searching for books and fetching book details.
*   **Models:** A `Book` model class represents the data structure for books, with a `fromJson` factory to parse API responses.

### Key Features

*   **Book Search:** Users can search for books by title, author, or keyword.
*   **Book Details:** Users can view detailed information about a book, including its cover, author, and description.
*   **Image Caching:** The `cached_network_image` package is used to cache book cover images, improving performance and reducing network usage.
*   **Dynamic Sliders:** The home screen features carousels of recommended books, powered by the `carousel_slider` package.
*   **Error Handling:** The app includes error handling for API requests and image loading, providing a more robust user experience.

## Current Plan

I will now focus on enhancing the user interface and adding new features to make the app more engaging and intuitive.

### Immediate Steps

1.  **Enhance the UI:** I will refine the UI of the book details screen, search screen, and library screen to improve the overall look and feel of the app.
2.  **Add a Bottom Navigation Bar:** I will implement a bottom navigation bar to provide a more intuitive and user-friendly way to navigate between the different screens of the app.
3.  **Implement Local Storage:** I will add local storage functionality to allow users to save their favorite books and create a personal library.
