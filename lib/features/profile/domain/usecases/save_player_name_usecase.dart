import '../repositories/profile_repository.dart';

class SavePlayerNameUseCase {
  SavePlayerNameUseCase(this._repo);

  final ProfileRepository _repo;

  Future<void> call(String name) => _repo.savePlayerName(name);
}
