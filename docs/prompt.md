
# Role: Senior Flutter Architect

## Task: Implement a robust Authentication System in Flutter using Clean Architecture principles (MVVM + Domain Layer)

## Requirements

1. Multiple Login Strategies: Implement a Strategy Pattern to handle different login methods: Email/Password, Social Media (Google/Apple), and Phone Number (mocked API).

2. Domain Layer: Create an AuthUseCase to orchestrate the business logic. It should not depend on specific implementation details of the providers.

3. Data Layer: Implement an AuthRepository interface.

    Create a LocalDataSource for persistence (using flutter_secure_storage or similar) to handle session tokens.

    Create a RemoteDataSource for API calls.

4. State Management: Use command pattern with change notifier to manage UI states.

5. Multi-user Support: The architecture should allow for session switching. The SessionManager should be a singleton that exposes the current user as a Stream.

## Architecture Specifications

Use Entities for business rules and Models (DTOs) for data serialization/deserialization.

Ensure Dependency Injection (e.g., GetIt) is used to decouple layers.

Implement a custom Failure class for domain-specific error handling.

Follow the "Dependency Rule": Inner layers (Domain) must not know anything about outer layers (Data/UI).

Output: > Please provide the folder structure, the core abstract classes for the Strategy pattern, the UseCase implementation, and an example of how the ViewModel/Controller interacts with the UseCase.

### Refs

1. [command-pattern](<https://docs.flutter.dev/app-architecture/design-patterns/command>)

2. [offlinep-first](<https://docs.flutter.dev/app-architecture/design-patterns/offline-first>)

3. [result pattern (dartz (left,right))](https://docs.flutter.dev/app-architecture/design-patterns/result)

4. Navigator 2.0
