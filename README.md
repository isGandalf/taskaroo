# Taskaroo - a todo app✅

Taskaroo is a simple and efficient Todo App built with Flutter. It helps users manage their daily tasks through a clean and intuitive interface. The app supports user authentication, allows users to create, store, and sync todo tasks seamlessly across devices, and enables sharing tasks with others for collaboration.

## Demo and Screesnshots
<table align="center" style="border-collapse: collapse;">
  <tr>
    <td align="center">
      <img src="https://github.com/isGandalf/taskaroo/blob/main/projectimages/Screenshot_20250508-193104.jpg" width="450"><br>
      <p align="center"><small>Sign Up</small></p>
    </td>
     <td align="center">
      <img src="https://github.com/isGandalf/taskaroo/blob/main/projectimages/Screenshot_20250508-194431.jpg" width="450"><br>
      <p align="center"><small>Drawer</small></p>
    </td>
    <td align="center">
      <img src="https://github.com/isGandalf/taskaroo/blob/main/projectimages/Screenshot_20250508-194446.jpg" width="450"><br>
      <p align="center"><small>My tasks page</small></p>
    </td>
    <td align="center">
      <img src="https://github.com/isGandalf/taskaroo/blob/main/projectimages/Screenshot_20250508-191004.jpg" width="450"><br>
      <p align="center"><small>My tasks page</small></p>
    </td>
    <td align="center">
      <img src="https://github.com/isGandalf/taskaroo/blob/main/projectimages/Screenshot_20250508-191035.jpg" width="450"><br>
      <p align="center"><small>Dark theme</small></p>
    </td>
  </tr>
</table>

## ✨ Features

- **User Authentication**  
  Sign up and log in securely using Firebase Authentication. Authentication state is preserved across sessions.

- **Local Task Storage with Isar**  
  Tasks are stored locally using Isar DB, ensuring fast access and offline availability.

- **Cloud Sync with Firestore**  
  Tasks are automatically synced to Firestore when online. This provides backup and lets users access their todos from multiple devices.

- **Create, Edit, Delete Todos**  
  Add new tasks, update them, or remove them as needed with a smooth and intuitive UI.

- **Share Tasks**  
  Share tasks with others via email. After creating a task, tap the share icon to send it to anyone using their email address.


## 🛠 Technologies Used  

Taskaroo is built using the following technologies and packages:

#### **📌 Framework & Language**  
- **Flutter** – For building the cross-platform UI  
- **Dart** – The programming language used  

#### **📌 State Management**  
- **BLoC** – For managing app state in a reactive and scalable way using the BLoC (Business Logic Component) pattern.  

#### **📌 API & Networking**  
- **Firebase Authentication** – Handles user sign-in and authentication.  
- **Cloud Firestore** – Stores and syncs todo tasks with the cloud.  

#### **📌 Local Storage**  
- **Isar DB** – Stores todo tasks locally for offline use.  

#### **📌 UI & Utilities**  
- **Expansion Tile Group** – Provides expandable task groups for better organization.  
- **intl** – For formatting date and time in different locales.  
- **path_provider** – Helps find the correct directory for local file storage.  

#### **📌 Other Utilities**  
- **Logger** – For logging app activities.  
- **dart_either** – A functional programming library used for error handling.  

## 📈 Flowchart

## 📁 Folder Structure

The project follows **Clean Architecture** principles, separating concerns across three main layers:
```
lib/
├── core/ # Common utilities, constants, theme, etc.
├── features/
|    |
│    ├── auth/ # User authentication feature
│    │      ├── data/ # Firebase data sources, sync, models
│    │      ├── domain/ # Entities, repositories, use cases for user auth
│    │      └── presentation/ # UI, widgets and BLoC logic for auth
|    |  
│    └── todo/ # Todo feature with sharing
│           ├── data/ # Isar data sources, models
│           ├── domain/ # Entities, respositories, use cases for creating tasks
│           └── presentation/ # UI, widgets, and BLoC logic for task use cases
|
├── main.dart # Entry point
└── firebase_options.dart # Dependency injection setup
```

This structure promotes testability, scalability, and separation of concerns.

## 📌 Usage

Here’s how you can use Taskaroo:

#### 👤 User authentication
- You can log in through the Login screen by providing your credentials (email and password), or tap on Don't have an account? to create a new account.
- If you have an account but forgot your password, tap on the Forgot password? link to reset it. A reset link will be sent to your registered email.

#### 📝 Create a Task
- Tap the **add button** to open the task creation dialog box.
- Enter task and tap on 'check' ✅ to save the task.

#### ✅ Toggle Task Completion
- Tap on checkbox of any task to mark it as complete or incomplete.

#### ✏️ Edit a Task
- Tap on task to expand and then tap ✏️ to edit.

#### 🗑️ Delete a Task
- Tap on task to expand and then tap 🗑️ to delete.

#### 📤 Sync Tasks
- Tasks are synced automatically on app resume.
- Manual sync is also available via a **sync button** on top right.

#### 👥 View Shared Tasks
- Go to the **Shared Tasks** tab to see todos shared with you.

#### 🔗 Share a Task
- After creating a task, tap on 'share' icon beside task title to share with anyone using email. (Note, the app does not lookup email at this stage therefore, ensure the email exists with the app before sharing).


## 🛠 Installation
Follow these steps to set up and run Taskaroo locally:

#### ⚙️ Prerequisites:  
The project has release build ready therefore, you need Android Sign-in setup. Follow [these](https://docs.flutter.dev/deployment/android#create-an-upload-keystore) steps to create your key. Since this is a private secure key, it has been excluded in .gitignore

#### 📥 Setup & Run Taskaroo

1️⃣ Clone the Repository
```
git clone https://github.com/yourusername/taskaroo.git
cd taskaroo
```
2️⃣ Install Dependencies
```
flutter pub get
```
3️⃣ Run the App
```
flutter run
```

## 🚀 Future Improvements

- **Push Notifications with reminders**  
  Implement push notifications to remind users about upcoming tasks and deadlines.

- **Voice Input for Task Creation**  
  Integrate voice recognition to let users add tasks hands-free.

- **Recurring Tasks**  
  Implement recurring task functionality to set tasks that repeat daily, weekly, or monthly.

## 🤝 Contributing
Contributions are welcome! If you'd like to improve or implement new features to Taskaroo, please go ahead. Since, I am just a beginner in this space, feel free to send me your suggestions and code Improvements.
