import '../../show_user_information_component.dart';

/// Show user information repository.
class ShowUserInformationRepository
    implements BaseShowUserInformationRepository {
  /// Initializes [ShowUserInformationRepository].
  ShowUserInformationRepository(this.mapper);

  @override
  final ShowUserInformationMapper mapper;

  @override
  Future<ShowUserInformationEntity> fetchUserInformation() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return mapper.toEntity(
      ShowUserInformationModel.fromJson(
        <String, dynamic>{'name': 'John Doe', 'birthdate': '1985-11-11'},
      ),
    );
  }
}
