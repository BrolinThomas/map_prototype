# Flutter Project Architecture

## Overview

This project uses a simple, feature-oriented architecture designed for small to medium Flutter applications, focusing on clarity, speed of development, and maintainability rather than heavy abstractions.

The architecture follows Clean Architecture principles but avoids unnecessary complexity like strict domain/data layers, code generation, or DI frameworks.

## Folder Structure

```
lib/
├── blocs/          # Business logic and state management
├── services/       # External interactions (API, Firebase, etc.)
├── models/         # Pure Dart data models
├── presentation/   # Screens and pages
├── widgets/        # Reusable UI components
├── utils/          # Helpers, constants, extensions
└── constants/      # App-wide constants (colors, strings, etc.)
```

## Architectural Principles

### 1. Clear Separation of Responsibilities

Each folder has a single, well-defined responsibility:

**blocs/**
- Contains all BLoC classes (events, states, logic)
- Handles business logic and state transitions
- No UI code or direct API calls

**services/**
- Handles all external interactions:
  - API calls (Dio)
  - Firebase / other SDKs
  - Local storage operations
- No UI or state logic exists here
- Pure service layer

**models/**
- Pure Dart data models used across the app
- Framework-agnostic (no Flutter imports)
- Serialization/deserialization logic
- Immutable data structures

**presentation/**
- Contains screens/pages only
- UI listens to BLoC state and dispatches events
- Minimal business logic
- Focuses on user interaction

**widgets/**
- Reusable UI components shared across multiple screens
- Stateless when possible
- Configurable via parameters

**utils/**
- Helper functions
- Constants and enums
- Extensions
- Formatters and validators

## State Management (BLoC)

### Core Principles

- Each feature has its own BLoC
- UI communicates with BLoC via **events**
- UI updates based on **states**
- BLoC does not contain UI code
- BLoC does not make raw API calls directly

### Data Flow

```
UI → Bloc → Service → Model → Bloc State → UI
```

### Example Flow

1. User taps a button (UI)
2. UI dispatches an event to BLoC
3. BLoC calls a service method
4. Service fetches data and returns a model
5. BLoC emits a new state
6. UI rebuilds based on the new state

## Dependency Injection Strategy (Manual DI)

This project uses **manual dependency injection**, meaning:

- Dependencies are created explicitly
- Passed via constructors
- No DI framework (GetIt / Injectable) is used

### Why Manual DI?

✅ Simpler mental model  
✅ Easier debugging  
✅ Clear visibility of dependencies  
✅ Sufficient for small–medium projects  

### Example

```dart
final dioClient = DioClient();
final movieService = MovieService(dioClient);

BlocProvider(
  create: (_) => MovieBloc(movieService),
  child: MoviePage(),
);
```

This keeps dependencies explicit and predictable.

## Why This Architecture Was Chosen

### ✅ Advantages

- Minimal boilerplate
- Fast development
- Easy onboarding for new developers
- Easy to refactor as the app grows
- Still testable and scalable

### ❌ What We Intentionally Avoid

- Overengineering
- Strict domain/data/presentation layers
- Code generation (build_runner)
- Global service locators for small features

## Clean Architecture Compliance (Simplified)

Although simplified, this structure still respects core Clean Architecture ideas:

- UI is separate from business logic
- Business logic is separate from data sources
- Models are framework-agnostic
- Dependencies flow inward (UI → Bloc → Service)

**This is Clean Architecture adapted for real-world Flutter apps, not academic demos.**

## Scalability Plan

If the application grows in complexity, this architecture can be evolved by:

1. Introducing repository interfaces
2. Splitting services into data sources
3. Adding a domain layer
4. Introducing a DI framework if needed

**No rewrite is required — only incremental refactoring.**

## Best Practices

### BLoC Guidelines

- Keep BLoCs focused on a single feature
- Use sealed classes for events and states (Dart 3+)
- Handle errors gracefully with error states
- Avoid business logic in UI

### Service Guidelines

- Services should be stateless
- Return models, not raw JSON
- Handle exceptions and return Result types when appropriate
- Keep API logic separate from business logic

### Model Guidelines

- Use immutable classes (final fields)
- Implement `copyWith` for updates
- Add `toJson` and `fromJson` for serialization
- Keep models simple and focused

### UI Guidelines

- Keep widgets small and focused
- Extract reusable components to `widgets/`
- Use BlocBuilder/BlocListener appropriately
- Avoid business logic in presentation layer

## Testing Strategy

- **Unit Tests**: Test BLoCs and services independently
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user flows
- Mock services when testing BLoCs
- Use test doubles for external dependencies

## Summary

This architecture prioritizes:

- **Simplicity** - Easy to understand and navigate
- **Readability** - Clear code organization
- **Maintainability** - Easy to modify and extend
- **Practical scalability** - Grows with your needs

It is intentionally designed to be production-ready without being over-engineered, making it ideal for real-world Flutter applications.
