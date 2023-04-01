import 'package:ferry/ferry.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'global/graphql/client.dart';
import 'global/providers/auth_provider.dart';
import 'global/services/hive_service.dart';
import 'global/utils/constants.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await Hive.initFlutter();
  await Hive.openBox(Constants.hiveDataBox);
  await Hive.openBox(Constants.hiveGraphqlBox);

  final appClient = AppClient();
  final client = await appClient.initClient();

  locator.registerLazySingleton<Client>(() => client);

  locator.registerLazySingleton<HiveService>(() => HiveServiceImpl());
  locator.registerLazySingleton<AuthProvider>(() => AuthProvider());
}
