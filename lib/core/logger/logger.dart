import 'package:loggy/loggy.dart';

mixin BlocLoggy implements LoggyType {
  @override
  Loggy<BlocLoggy> get loggy =>
      Loggy<BlocLoggy>('Bloc - ${runtimeType.toString()}');
}

mixin ErrorLoggy implements LoggyType {
  @override
  Loggy<ErrorLoggy> get loggy => Loggy<ErrorLoggy>('Fatal Error');
}

class ErrorLogger with ErrorLoggy {
  void logError(Object error, [StackTrace? stackTrace]) {
    loggy.error(error);
  }
}
