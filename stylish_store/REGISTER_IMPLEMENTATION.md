# Register Logic Implementation - Layered Architecture

## Overview
This document describes the complete implementation of user registration with a clean layered architecture following Flutter best practices.

## Architecture Layers

### 1. **Networking Layer** (`data/networking/`)
**File**: `auth_api_client.dart`

Handles all HTTP communication with the API:
- Configures Dio HTTP client with base URL, timeouts
- Implements `register()` method that calls the Platzi API
- Manages request/response serialization
- Throws `DioException` for network/API errors

```dart
Future<RegisterResponse> register(RegisterRequest request)
```

### 2. **Data Models** (`data/models/`)

#### RegisterRequest
**File**: `register_request.dart`
- Contains user input: email, password, name
- Converts to JSON for API request via `toJson()`
- Uses Equatable for value comparison

#### RegisterResponse
**File**: `register_response.dart`
- Represents API response data
- Parses JSON from API via `fromJson()` factory
- Contains user ID, email, name, avatar, role, creationAt

### 3. **Error Handling** (`core/failures/`)

#### Failure Classes (`failure.dart`)
- `Failure` - Abstract base class
- `NetworkFailure` - Connection/timeout issues
- `ServerFailure` - HTTP errors (500, 503, etc.)
- `ValidationFailure` - Input validation errors
- `UnknownFailure` - Unexpected errors

#### Result Wrapper (`result.dart`)
- `Result<T>` - Abstract result type
- `Success<T>` - Success case with data
- `Error<T>` - Error case with Failure

### 4. **Repository Layer** (`data/repositories/`)
**File**: `auth_repository.dart`

Implements business logic and error mapping:

```dart
abstract class AuthRepository {
  Future<Result<RegisterResponse>> register(RegisterRequest request);
}
```

**Error Mapping Strategy:**
- Maps `DioException` types to specific `Failure` types
- HTTP 400 → `ValidationFailure`
- HTTP 409 → `ValidationFailure` (email exists)
- HTTP 500/503 → `ServerFailure`
- Connection issues → `NetworkFailure`
- Extracts error messages from API response

### 5. **State Management** (`logic/cubits/`)

#### RegisterState (`register_state.dart`)
State classes using Equatable:
- `RegisterInitial` - Initial state
- `RegisterLoading` - API call in progress
- `RegisterSuccess` - Registration successful
- `RegisterFailure` - Registration failed

#### RegisterCubit (`register_cubit.dart`)
Manages registration state and business logic:

```dart
Future<void> register({
  required String email,
  required String password,
  required String name,
})
```

**Features:**
- Client-side input validation before API call
- Email format validation using regex
- Password minimum length check (6 chars)
- Name validation (non-empty, min 2 chars)
- Emits `ValidationFailure` for invalid inputs
- Handles API success/error responses
- Provides `reset()` method to clear state

### 6. **Service Locator** (`features/auth/services/`)
**File**: `auth_service_locator.dart`

Singleton pattern for dependency injection:
- Initializes API client, repository, and cubit
- Provides getter methods for each component
- Single setup call in `main()`
- Prevents duplicate instances

## Input Validation

### Client-Side Validation (in RegisterCubit)
1. **Email**
   - Not empty
   - Valid format: `name@domain.ext`

2. **Password**
   - Not empty
   - Minimum 6 characters

3. **Name**
   - Not empty
   - Minimum 2 characters

### Server-Side Validation
- API returns 400 for invalid fields
- API returns 409 if email already exists
- Messages extracted and displayed to user

## Error Handling Strategy

### Network Errors
- Connection timeout
- Send/receive timeout
- No internet connection
- → User message: "Please check your internet connection"

### Server Errors
- 400 Bad Request → Validation error
- 409 Conflict → Email already exists
- 500 Server Error → Server error
- 503 Unavailable → Service temporarily unavailable

### Validation Errors
- Invalid email format
- Password too short
- Name too short
- Empty fields

## Usage in UI

### SignupView Integration
```dart
// Wrap with BlocProvider
BlocProvider(
  create: (_) => AuthServiceLocator().registerCubit,
  child: const SignupView(),
),

// Listen to state changes
BlocListener<RegisterCubit, RegisterState>(
  listener: (context, state) {
    if (state is RegisterSuccess) {
      // Show success dialog
    } else if (state is RegisterFailure) {
      // Show error dialog
    }
  },
)

// Observe loading state
BlocBuilder<RegisterCubit, RegisterState>(
  builder: (context, state) {
    final isLoading = state is RegisterLoading;
    return AuthButton(
      isLoading: isLoading,
      onPressed: isLoading ? null : _handleSignup,
    );
  },
)

// Trigger registration
context.read<RegisterCubit>().register(
  email: emailController.text,
  password: passwordController.text,
  name: nameController.text,
);
```

## File Structure
```
lib/
├── core/
│   └── failures/
│       ├── failure.dart
│       └── result.dart
├── features/auth/
│   ├── data/
│   │   ├── models/
│   │   │   ├── register_request.dart
│   │   │   └── register_response.dart
│   │   ├── networking/
│   │   │   └── auth_api_client.dart
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   └── validators/
│   │       └── auth_validators.dart
│   ├── logic/
│   │   └── cubits/
│   │       ├── register_cubit.dart
│   │       └── register_state.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   └── signup_view.dart
│   │   └── widgets/
│   │       ├── auth_text_field.dart
│   │       └── auth_button.dart
│   └── services/
│       └── auth_service_locator.dart
```

## Dependencies Added
```yaml
dio: ^5.4.0              # HTTP client
flutter_bloc: ^8.1.4     # State management
bloc: ^8.1.2             # BLoC library
equatable: ^2.0.5        # Value equality
```

## API Endpoint
- Base URL: `https://api.platzi.com/v1`
- Endpoint: `POST /users`
- Request body:
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }
  ```
- Success response (201):
  ```json
  {
    "id": 123,
    "email": "user@example.com",
    "name": "John Doe",
    "avatar": "https://...",
    "role": "customer",
    "creationAt": "2024-05-20T10:30:00.000Z"
  }
  ```

## Best Practices Implemented

1. **Separation of Concerns** - Each layer has a single responsibility
2. **Error Handling** - Comprehensive error mapping and clean messages
3. **Input Validation** - Client-side before API, server-side validation
4. **State Management** - BLoC pattern for predictable state changes
5. **Dependency Injection** - Service locator for loose coupling
6. **Immutability** - Equatable for value equality
7. **Type Safety** - Generic Result<T> wrapper
8. **User Experience** - Loading states, error dialogs, success feedback
9. **Code Reusability** - Validators, models, and error classes are reusable
10. **Testability** - Each layer can be tested independently

## Next Steps (Optional Enhancements)

1. Add unit tests for cubit validation and state transitions
2. Add repository integration tests
3. Add mock API client for testing
4. Implement offline support with caching
5. Add biometric authentication
6. Implement email verification flow
7. Add rate limiting for API requests
8. Implement password strength meter
