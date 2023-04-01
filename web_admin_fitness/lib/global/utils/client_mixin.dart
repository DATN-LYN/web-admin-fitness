import 'package:ferry/ferry.dart';

import '../../locator.dart';
import '../services/hive_service.dart';

mixin ClientMixin {
  final hiveService = locator.get<HiveService>();
  final client = locator.get<Client>();
}
