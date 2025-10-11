class AppConfig {
  final Environment environment;
  final String baseUrl;
  final String appName;

  static late final AppConfig _instance;

  AppConfig._internal({required this.environment, required this.baseUrl, required this.appName});

  static void initialize({required Environment environment, required String baseUrl, required String appName}) {
    _instance = AppConfig._internal(environment: environment, baseUrl: baseUrl, appName: appName);
  }

  static AppConfig get instance => _instance;
  
   String get collectionPrefix =>
      switch (environment) { Environment.dev => 'dev_', Environment.prod => '' };
}

enum Environment { dev, prod }
