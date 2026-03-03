# Users API Flutter App

A Flutter application that demonstrates best practices for fetching and displaying data from an API with proper state management and error handling. It also includes basic Firebase integration; ensure the `com.google.gms.google-services` plugin is applied in `android/app/build.gradle.kts` and the `google-services.json` file is present.

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── user_model.dart      # User data model with JSON serialization
├── services/
│   └── user_service.dart    # API service with error handling (try-catch)
├── screens/
│   └── home_screen.dart     # Main screen with state management
└── widgets/
    ├── user_card.dart       # User card item widget
    ├── loading_widget.dart  # Loading indicator widget
    └── error_display.dart   # Error state widget with retry button
```

## ✨ Features

### 1. **State Management with 3 States**

- **Loading State**: Shows `CircularProgressIndicator` while fetching data
- **Success State**: Displays users in a scrollable ListView with RefreshIndicator
- **Error State**: Shows error message with a "Retry" button

### 2. **API Integration**

- Uses `http` package to fetch data from JSONPlaceholder API
- **Safe Error Handling**: All API calls wrapped in try-catch blocks
- Timeout handling (10 seconds)
- Proper exception messages

### 3. **UI Components**

- **LoadingWidget**: Centered loading indicator with message
- **ErrorWidget**: Error icon, message, and retry button
- **UserCard**: Neat card layout with user info, proper spacing, and text truncation
- **RefreshIndicator**: Pull-to-refresh on success state

### 4. **User Card Features**

- User name with ID badge
- Email, phone, company, and website
- Icons for each field
- Text overflow handling with ellipsis
- Responsive design

## 🚀 How to Run

### Prerequisites

- Flutter SDK installed
- Device or emulator available

### Steps

1. **Get dependencies**:

   ```bash
   flutter pub get
   ```

   Make sure your Firebase settings (google-services.json) are in place.

2. **Run the app**:
   ```bash
   flutter run
   ```

## 🧪 Testing Different States

### 1. **Loading State** (Default)

- The app automatically shows loading state on startup
- See the CircularProgressIndicator spinning

### 2. **Success State**

- Wait a moment for the API to respond
- Users list will appear in a ListView
- Each user is displayed in a Card widget
- Tap refresh icon to reload data

### 3. **Error State** (To Simulate)

- Open `lib/screens/home_screen.dart`
- In `_fetchUsers()` method, replace:
  ```dart
  final users = await UserService.fetchUsers();
  ```
  with:
  ```dart
  final users = await UserService.fetchUsersWithError();
  ```
- Hot reload the app
- You'll see the error state with a "Retry" button
- Tap "Retry" to go back to loading state

## 📝 Code Organization Benefits

1. **Separation of Concerns**
   - Models: Data structure
   - Services: API communication
   - Screens: UI logic and state
   - Widgets: Reusable UI components

2. **Easy Maintenance**
   - Each file has single responsibility
   - Easy to locate and modify code
   - Easy to unit test

3. **Error Handling**
   - Try-catch blocks in UserService
   - Graceful error messages
   - Retry functionality

## 🔧 Error Handling Implementation

### UserService (`lib/services/user_service.dart`)

```dart
static Future<List<User>> fetchUsers() async {
  try {
    // API call with timeout
    final response = await http.get(...).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Parse and return data
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Error fetching users: $e');
  }
}
```

### HomeScreen (`lib/screens/home_screen.dart`)

- Uses `LoadingState` enum to track state
- setState to update UI
- Try-catch in `_fetchUsers()` method
- Proper error message display

## 📦 Dependencies

- **flutter**: UI framework
- **http**: HTTP client for API calls
- **firebase_core**: Required to initialize Firebase
- **firebase_analytics**: Example Firebase product used
- **material_design_icons**: Already available in Flutter

## 🎨 UI/UX Highlights

1. **Loading**: Beautiful centered spinner with message
2. **Error**: Clear error icon, message, and action button
3. **Success**:
   - Clean card layout
   - Icon indicators for each field
   - Pull-to-refresh functionality
   - Empty state handling

## 📱 Testing on Different Devices

The app is responsive and works on:

- Android phones and tablets
- iOS devices
- Web (if web support is enabled)
- Desktop (Linux, macOS, Windows)

## 🐛 Troubleshooting

1. **No internet connection error**:
   - Check your network connection
   - Look at the error message
   - Tap "Retry" button

2. **App not responding**:
   - The app has a 10-second timeout
   - If API takes longer, you'll see an error
   - Tap "Retry" to try again

3. **Data not loading**:
   - Check internet connection
   - Try tapping the refresh icon
   - Or pull down to refresh the list

## 📚 Learning Points

This app demonstrates:

- State management with setState
- Fetching data from REST API
- Error handling with try-catch
- JSON serialization/deserialization
- Widget composition
- Code organization best practices
