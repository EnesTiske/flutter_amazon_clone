# Mobile Banking Application

## About Me

Hello! I’m Mehmet Enes Tiske, a third-year Computer Engineering student at Gazi University. With a keen interest in software development, I enjoy creating applications that make everyday tasks easier and more efficient. This mobile banking application represents my commitment to leveraging technology to improve financial management and user experience.

## Project Overview

The Mobile Banking Application is designed to provide users with a convenient and secure way to manage their finances from their mobile devices. The application aims to replicate the core functionalities of traditional banking while incorporating modern technology to enhance user experience and accessibility. Users can perform various banking operations, such as checking balances, transferring funds, and managing accounts directly from their smartphones.

## Key Features

### User Authentication
The application implements a secure user authentication system, ensuring that only authorized users can access their accounts. This feature includes options for password recovery and account verification, prioritizing user security.

### Account Management
Users can view and manage their bank accounts effortlessly. The app provides real-time balance updates, transaction history, and account details, allowing users to stay informed about their financial status at all times.

### Fund Transfers
The app simplifies the process of transferring funds between accounts, whether within the same bank or to other banks. Users can initiate transfers with just a few taps, making banking more efficient and user-friendly.

### Bill Payments
Users can pay bills directly through the app, eliminating the need for physical visits to banks or payment centers. This feature streamlines the bill payment process and allows users to schedule payments for added convenience.

### Notifications and Alerts
To keep users informed about important account activities, the application sends notifications and alerts. Users can receive updates on transactions, low balance warnings, and payment reminders, ensuring they are always aware of their financial activities.

### User-Friendly Interface
The application is designed with an intuitive interface, making it easy for users to navigate and access the various features. The user experience is prioritized, ensuring that even those with limited tech skills can use the app with ease.

## Technologies Used

- **Programming Language**: Java – The primary language used for developing the application.
- **Framework**: Android SDK – For building the Android application and leveraging native features.
- **Database**: SQLite – For local data storage, allowing for offline access to account information and transaction history.
- **Networking**: Retrofit – For handling network requests and interacting with banking APIs securely.

## Future Enhancements

As I work on improving this application, I plan to add the following features:
- Integration with biometric authentication (e.g., fingerprint or facial recognition) for enhanced security.
- Enhanced transaction analytics, providing users insights into their spending habits.
- Multi-language support to cater to a broader audience.
- Improved error handling and user feedback for transactions to enhance overall usability.

## Installation and Setup Guide

### Prerequisites
- Node.js (v14.0.0 or higher)
- Flutter SDK (latest version)
- Java Development Kit (JDK)
- Android Studio or VS Code
- Git

### Installation Steps

1. Clone the project:
```bash
git clone https://github.com/yourusername/mobile-banking-application.git
cd mobile-banking-application
```

2. For the backend server:
```bash
cd server
npm install
npm start
```

3. For the web client:
```bash
cd web-client
npm install
npm start
```

4. For the mobile application:
```bash
cd mobile-app
flutter pub get
flutter run
```

### Environment Variables
- Create a `.env` file for the backend and add the necessary variables:
```
PORT=3000
MONGODB_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
```

### Testing
- For backend tests: `cd server && npm test`
- For web client tests: `cd web-client && npm test`
- For Flutter tests: `cd mobile-app && flutter test`

### Notes
- Make sure MongoDB is installed and running before starting the application
- An Android emulator or physical device is required to run the mobile application
- All services (backend, web-client, mobile-app) need to be running simultaneously

## Contact

I welcome any questions, feedback, or collaboration opportunities! Feel free to reach out to me at **menes.tiske@gmail.com**. I’m always eager to connect with fellow developers and learn from the community.

