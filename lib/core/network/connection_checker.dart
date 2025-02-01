import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImply implements ConnectionChecker {
  final InternetConnectionChecker internetConnection;
  ConnectionCheckerImply(this.internetConnection);
  @override
  Future<bool> get isConnected async => await internetConnection.hasConnection;
}
