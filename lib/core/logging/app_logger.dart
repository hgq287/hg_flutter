import 'package:logger/logger.dart';

/// Debug logger. `logger` hides output in release by default when configured.
final Logger logger = Logger(printer: SimplePrinter());
