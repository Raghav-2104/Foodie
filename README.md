# Welcome to Foodie

Foodie is a Flutter app that allows users to order food from their favorite restaurant. The app features a real-time menu cart, order detail generation, and admin ability to update the menu.


#  Features

-   Real-time menu cart: Users can add items to their cart in real time, and the total price will be updated automatically.
-   Order detail generation: When a user places an order, the app will generate a detailed order receipt that includes the items ordered, the price, and the order status.
-   Admin ability to update menu: Admins can update the menu in realtime, and the changes will be reflected in the app for all users.

## Getting Started

To get started with Foodie, you will need to:

1.  Install Flutter.
2.  Clone the Foodie repository.
3.  Run  `flutter pub get`  to install the dependencies.
4.  Create a new file inside lib :- lib/Keys/Unsplash.dart
5.  Create Unsplash Developers account , create a project and get your ACCESSKEY.
6.  Paste the following Code :-
    class Unsplash {
        static const String UnSplashACCESSKEY = 'YOUR_ACCESS_KEY';
    }
7.  Run  `flutter run`  to start the app.

## Features to be added
- Updating images dynamically.
- Showing order details of all the customers in the admin panel.
- Payment mode integration.
- Check weather user is logged in from google or email & password and display his data accordingly.

## Bugs

-Currently no bugs

##  Contributing

Contributions to Foodie are welcome! If you find a bug or have an idea for a new feature, please open an issue on the GitHub repository.
