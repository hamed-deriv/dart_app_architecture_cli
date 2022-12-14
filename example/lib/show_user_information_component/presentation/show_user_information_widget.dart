import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app_architecture/components.dart';

import '../show_user_information_component.dart';

/// Show user information widget.
class ShowUserInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BaseWidget<ShowUserInformationEntity,
          ShowUserInformationModel, ShowUserInformationCubit>(
        initialWidgetBuilder: (
          BuildContext context,
          BaseState<ShowUserInformationEntity> state,
        ) =>
            const SizedBox.shrink(),
        loadingWidgetBuilder: (
          BuildContext context,
          BaseState<ShowUserInformationEntity> state,
        ) =>
            const CircularProgressIndicator(),
        successWidgetBuilder: (
          BuildContext context,
          BaseState<ShowUserInformationEntity> state,
        ) =>
            _buildUserInformation(state.data),
        errorWidgetBuilder: (
          BuildContext context,
          BaseState<ShowUserInformationEntity> state,
        ) =>
            Text('${state.error}'),
      );

  Widget _buildUserInformation(ShowUserInformationEntity? userInformation) =>
      userInformation == null
          ? const Text('-')
          : Column(
              children: <Widget>[
                Text('Name: ${userInformation.name}'),
                const SizedBox(height: 8),
                Text(
                  'Birthdate: ${userInformation.birthdate == null ? '-' : DateFormat('yyyy-MM-dd').format(userInformation.birthdate!)}',
                ),
              ],
            );
}
