# ToDo List Application

This project demonstrates the implementation of a **ToDo List** application with core features like task management, persistent data storage, API integration, and multithreading. The app is designed with clean architecture and adheres to modern iOS development practices.

## Features

### 1. Task List
- Display a list of tasks on the main screen.
- Each task includes:
  - **Title**
  - **Description**
  - **Creation Date**
  - **Status**: Completed/Incomplete.
- **Task Management**:
  - Add new tasks.
  - Edit existing tasks.
  - Delete tasks.
- **Search Functionality**:
  - Quickly search through tasks by title or description.

### 2. API Integration
- On the first launch, the app fetches tasks from the [DummyJSON API](https://dummyjson.com/todos).
- The fetched tasks are stored locally in CoreData for persistent use.

### 3. Multithreading
- All task-related operations (loading, creating, editing, deleting, and searching) are executed on background threads using **GCD** to ensure the interface remains responsive.

### 4. Persistent Data (CoreData)
- Tasks are stored in CoreData for offline use.
- The app restores all data from CoreData when relaunched.

### 5. Version Control
- The project is version-controlled using Git.

### 6. Unit Testing
- Comprehensive unit tests are written for the app’s core functionality, including task creation, editing, deletion, and API integration.

---

## Architecture

### VIPER
The application is structured using the **VIPER** architecture, ensuring clear separation of concerns and maintainable code:

- **View**: Responsible for UI and user interaction.
- **Interactor**: Handles business logic and background operations.
- **Presenter**: Acts as a mediator between View and Interactor.
- **Entity**: Represents the task data model.
- **Router**: Manages navigation and module assembly.

### Additional Design Notes
- The UI is based on the provided [Figma mockups](https://www.figma.com/design/ElcIDP3PIp5iOE4dCtPGmd/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B8?node-id=0-1&node-type=canvas&t=TwPJnfr4PqiaBY1N-11).
- API JSON: The dummy API JSON file is available [here](https://drive.google.com/file/d/1MXypRbK2CS9fqPhTtPonn580h1sHUs2W/view?usp=sharing).

---

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo/todo-list-app.gitTodo app
