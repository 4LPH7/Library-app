# My Library - A Personal Book Catalog App

Welcome to **My Library**, a feature-rich Flutter application designed to help you discover, track, and manage your reading journey. Built with a focus on a clean, modern, and intuitive user experience, this app serves as your personal digital bookshelf.

## Video Showcase

[**(video demonstration here)**](https://github.com/user-attachments/assets/d2b675b0-8b91-4f14-8078-b4489761014a)

## Screenshots

| HomeScreen | My Library | Book Details |
| :---: | :---: | :---: |
| ![Image](https://github.com/user-attachments/assets/dcb1ce47-50ac-4a9e-ab87-d942e203d847) | ![Image](https://github.com/user-attachments/assets/94aa7142-11e2-4224-90ab-26840748832b) | ![Image](https://github.com/user-attachments/assets/cf9a4587-9732-4948-a3b5-3fd810e64ef3) |
| *Discover new books* | *Currently reading and alredy read* | *View in-depth details* |

<!--
**Instructions for adding screenshots:**
1. Take screenshots of the different screens of your app.
2. Place them in a directory, for example, `docs/screenshots/`.
3. Replace the "(Add screenshot here)" placeholders with the path to your images.
   Example: `![Home Screen](./docs/screenshots/home.png)`
-->

## Getting Started

This project is a starting point for a Flutter application. To get a local copy up and running, follow these simple steps.

### Prerequisites

- **Flutter SDK:** Make sure you have the Flutter SDK installed. For help, view the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **IDE:** An IDE with Flutter support like VS Code or Android Studio.
- **Emulator or Physical Device:** To run the app.

### Installation & Launch

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/my-library.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd my-library
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

## Key Features

My Library is packed with features to provide a seamless and engaging user experience:

-   **📚 Powerful Book Search:** Instantly search for books by title, author, or general keywords using the Open Library API.
-   **📖 Detailed Book Information:** View rich details for each book, including its cover, subtitle, full description, and author information.
-   **✨ Dynamic & Modern UI:** A visually appealing interface built with Material 3 components, `google_fonts` for beautiful typography, and smooth animations.
-   **🚀 Carousel Sliders:** The home screen features an elegant, auto-playing carousel to showcase recommended and trending books.
-   ** Personal Library:**
    -   **Currently Reading List:** Keep track of the books you are currently reading.
    -   **Already Read List:** Maintain a list of all the books you have completed.
    -   **Local Persistence:** Your library is saved locally on your device, so your data is always available.
-   **🖼️ Advanced Image Caching:** Uses `cached_network_image` to efficiently load and cache book covers, ensuring fast performance and reducing data usage.
-   **🧭 Intuitive Navigation:** A sleek bottom navigation bar allows for quick and easy switching between the Home screen, Search, and your personal Library.
-   **➕ Manual Entry:** Manually add books to your library that may not be available through the search.
-   **🔍 Author Recommendations:** The book details screen shows other works by the same author, helping you discover more books you might love.
-   **📱 Responsive Layout:** The UI is designed to be responsive and adapt gracefully to different screen sizes on both mobile and web.

## Visual Design Philosophy

Our design approach is centered on creating a beautiful, intuitive, and engaging user experience.

1.  **Aesthetics:** We use modern components, a visually balanced layout with clean spacing, and polished styles to make the app a pleasure to use.
2.  **Clarity & Intuitiveness:** The UI is designed to be easy to understand, with clear navigation and a logical flow.
3.  **Typography & Color:** We leverage `google_fonts` for expressive typography and a carefully selected color palette to create a vibrant and energetic look and feel.
4.  **Meaningful Imagery:** High-quality book covers are prominently displayed to create a visually rich browsing experience. Placeholder and error widgets ensure the UI remains graceful even when images can't be loaded.

## Technology Stack

This project leverages a modern Flutter technology stack to ensure a high-quality, maintainable, and scalable application.

-   **Framework:** [Flutter](https://flutter.dev/)
-   **State Management:** [Provider](https://pub.dev/packages/provider)
-   **HTTP Requests & API:** [http](https://pub.dev/packages/http) & [Open Library API](https://openlibrary.org/developers/api)
-   **UI Components:**
    -   [Carousel Slider](https://pub.dev/packages/carousel_slider)
    -   [Cached Network Image](https://pub.dev/packages/cached_network_image)
    -   [Google Fonts](https://pub.dev/packages/google_fonts)
-   **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)
-   **Linting:** [flutter_lints](https://pub.dev/packages/flutter_lints)
