class ServiceNotAvailable extends Error implements Exception {
  final String message;

  ServiceNotAvailable(this.message);
}
