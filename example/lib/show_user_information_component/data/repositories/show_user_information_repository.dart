import 'dart:math';

import '../../show_user_information_component.dart';

/// Show user information repository.
class ShowUserInformationRepository
    implements BaseShowUserInformationRepository {
  /// Initializes [ShowUserInformationRepository].
  const ShowUserInformationRepository(this.mapper);

  @override
  final ShowUserInformationMapper mapper;

  @override
  Future<ShowUserInformationEntity> fetchUserInformation() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final bool isFailed = Random().nextBool();

    if (isFailed) {
      throw Exception('Something goes wrong... :(');
    } else {
      return mapper.toEntity(
        ShowUserInformationModel.fromJson(
          <String, dynamic>{
            'name': 'John Doe',
            'birthdate': '${DateTime.now()}'
          },
        ),
      );
    }
  }
}
