abstract interface class ConnectivityService {
  Future<bool> get isOnline;
  Stream<bool> get statusChanges;
}
