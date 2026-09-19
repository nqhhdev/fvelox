enum FveloxToastType { success, error }

final class FveloxToastMessage {
  const FveloxToastMessage({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final FveloxToastType type;
}
