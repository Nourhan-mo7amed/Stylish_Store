class ApiEndpoints {
  static const String baseUrl = 'https://api.platzi.com/v1';

  // Auth endpoints
  static const String register = '/users';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String refreshToken = '/auth/refresh-token';

  // Users endpoints
  static const String users = '/users';
  static const String userById = '/users/:id';

  // Products endpoints
  static const String products = '/products';
  static const String productById = '/products/:id';

  // Categories endpoints
  static const String categories = '/categories';
  static const String categoryById = '/categories/:id';
}
