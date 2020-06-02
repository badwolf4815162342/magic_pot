import 'package:logger/logger.dart';

Logger getLogger() {
  return Logger(
    printer: PrettyPrinter(
      lineLength: 90,
//      colors: false,
      methodCount: 1,
      errorMethodCount: 5,
    ),
  );
}
