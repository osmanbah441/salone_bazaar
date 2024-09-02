# Tasks and Milestones

## Milestone: Project Initiation
- ✅ Write a brief README that explains your project, how to run it, and any key features.

## Milestone: Onboarding
- **Design the UI**
  - ❌ Registration Screen: UI for users to sign up with email and password, including fields for name, email, password, and role selection (Retailer/Customer).
  - ❌ Login Screen: UI for users to log in with their credentials, including a "Forgot Password?" option.
- **Implement the Front-End Code**
  - ❌ Registration Screen Implementation: Code the UI, handle form validation, and connect to Firebase Authentication for user sign-up.
  - ❌ Login Screen Implementation: Implement the login functionality and integrate Firebase Authentication for user sign-in.
- **Implement the Back-End Code**
  - ❌ Using Cloud Functions and the Admin SDK to manage user data and roles to centralize data management.
  - ❌ Enhance security by implementing custom claims to protect sensitive information.
  - **Testing**: ❌ Test all the screens to make sure everything is working as intended.

## Milestone: Product Management
- **Design the UI**
  - ❌ Product Listing Screen: UI for displaying products, allowing users to view images, titles, prices, and brief descriptions.
  - ❌ Product Details Screen: UI for showing detailed product information, including images, descriptions, pricing, and "Add to Cart" button.
- **Implement the Front-End Code**
  - ❌ Product Listing Implementation: Code the UI for the product listing, integrate Firestore to fetch product data, and handle dynamic rendering.
  - ❌ Product Details Implementation: Code the UI for the product details page, connect it to Firestore to fetch individual product data, and implement the "Add to Cart" functionality.
- **Implement the Back-End Code**
  - ❌ Back-end product management using Firebase Functions and Firestore triggers.
  - **Testing**: ❌ Ensure all product-related features work smoothly across different devices.

## Milestone: Checkout Process
- **Design the UI**
  - ❌ Shopping Cart Screen: UI for displaying items in the user's cart, allowing quantity adjustments, and showing the total price.
  - ❌ Checkout Screen: UI for entering payment details, selecting the delivery method, and confirming the order.
- **Implement the Front-End Code**
  - ❌ Shopping Cart Implementation: Code the UI for the shopping cart, connect it to Firestore to manage the cart data, and handle dynamic price updates.
  - ❌ Checkout Implementation: Code the checkout process, integrate payment options, and connect to Firebase Functions for processing orders.
- **Implement the Back-End Code**
  - ❌ Order processing using Firebase Functions and Firestore triggers.
  - **Testing**: ❌ Test the entire checkout process from adding items to the cart, through to order placement, to ensure seamless functionality.

## Milestone: Delivery Management (If Time Permits)
- **Design the UI**
  - ❌ Delivery Tracking Screen: UI for displaying real-time order tracking on a map.
- **Implement the Front-End Code**
  - ❌ Delivery Tracking Implementation: Code the UI for the delivery tracking screen, integrate Google Maps API, and connect to Firestore for real-time data updates.
- **Implement the Back-End Code**
  - ❌ Delivery status management using Firebase Functions and Firestore triggers.
  - **Testing**: ❌ Ensure the delivery tracking system is accurate and responsive.

## Future Milestones (If Time Permits)
- **Push Notifications**
- **Customer Reviews & Ratings**
- **Retailer Dashboard**
