# amazon_clone_tutorial

## About Me

Hello! I’m Mehmet Enes Tiske, a third-year Computer Engineering student at Gazi University. I’m passionate about learning and honing my skills in software development, and I believe in hands-on experience. As a student, I enjoy taking on clone projects to learn and practice new technologies, and this Amazon clone is one of my projects aimed at understanding the intricacies of e-commerce platforms.

## Project Overview

This project is an Amazon clone, built with the goal of mimicking the core features of an e-commerce site like Amazon. Through this project, I am exploring various aspects of full-stack development, including frontend design, backend logic, and database integration.

## Features Implemented

- User authentication and authorization
- Product catalog with search and filter functionality
- Product details page with dynamic data rendering
- Shopping cart and checkout process
- Order history and user profile management

## Future Plans

- Implementing a payment gateway simulation
- Adding responsive design for mobile views
- Further optimization and adding new features as I learn more

## Technologies Used

- **Frontend**: Flutter, Provider
- **Backend**: Node.js, Express
- **Database**: MongoDB, Cloudinary

## Authentication System

![Screenshot 2025-01-18 at 23 38 07](https://github.com/user-attachments/assets/aa672b80-e3ef-4a43-bd74-031b9c96c4c1)

### QR Code Authentication
The application implements a secure QR code-based authentication system that allows users to quickly log in to their web accounts using their mobile devices. This feature works as follows:

1. Web Interface generates a unique QR code containing a temporary session token
2. User scans this QR code using the mobile application
3. Mobile app verifies the token and establishes a secure connection
4. Upon successful verification, the web interface automatically logs in the user

### JWT Authentication
The application uses JSON Web Tokens (JWT) for secure authentication and authorization:

- Each successful login generates a unique JWT token
- Tokens are encrypted and contain user identification information
- All API requests require valid JWT tokens in the authorization header
- Tokens automatically expire after a set period for enhanced security
- Refresh token mechanism is implemented for seamless user experience

This dual-layer authentication system provides both security and convenience, allowing users to safely access their accounts across multiple devices.

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
git clone https://github.com/EnesTiske/flutter_amazon_clone.git
cd flutter_amazon_clone
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

