import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:solana_beach/features/dashboard/data/repositories/block_repository_impl.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';

class DependencyInjection {
  const DependencyInjection._();

  static void injectDependencies() {
    GetIt.I.registerSingleton<Client>(Client());
    _registerRepositories();
  }

  static void _registerRepositories() {
    GetIt.I.registerLazySingleton<BlockRepository>(
      () => BlockRepositoryImpl(client: GetIt.I<Client>()),
    );
  }
}
