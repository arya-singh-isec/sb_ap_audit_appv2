import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';

import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/partner.dart';
import '../../domain/entities/team_member.dart';
import '../blocs/get_team_members_bloc.dart';
import '../blocs/get_team_members_event.dart';
import '../blocs/get_team_members_state.dart';
import '../blocs/partners_bloc.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> with UiLoggy {
  static const Color _amberColor = Colors.amber;
  static const EdgeInsets _padding = EdgeInsets.all(16);
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(8));

  // Dummy data
  static const _fiscalYears = ['FY 2024-2025', 'FY 2023-2024'];
  static const _periods = ['First half', 'Second half'];

  // State variables
  String? _selectionType;
  final List<String?> _teamMemberSelections = [null];
  final Map<String, String?> _otherSelections = {
    'partner': null,
    'fiscalYear': null,
    'period': null
  };

  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    loggy.debug('Landed successfully on the partner selection screen');
    for (var key in ['partner', 'teamMember', 'fiscalYear', 'period']) {
      _focusNodes[key] = FocusNode();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Get Partners List
      BlocProvider.of<GetPartnersBloc>(context).add(FetchPartnersList());
      // Get TeamMembers List
      BlocProvider.of<GetTeamMembersBloc>(context).add(FetchTeamMembersList());
    });
  }

  @override
  void dispose() {
    // Dispose all focus nodes
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  void _updateSelection(String key, String? value) {
    loggy.debug('user selected $value for $key');
    setState(() {
      if (key == 'value') {
        _selectionType = value;
        _teamMemberSelections.clear();
        _teamMemberSelections.add(null);
      } else {
        _otherSelections[key] = value;
      }
    });
  }

  void _updateTeamMemberSelection(int level, String? value) {
    loggy.debug('user selected $value for team member level $level');
    setState(() {
      if (level >= _teamMemberSelections.length) {
        _teamMemberSelections.add(value);
      } else {
        _teamMemberSelections[level] = value;
        _teamMemberSelections.removeRange(
            level + 1, _teamMemberSelections.length);
      }
    });

    if (value != null) {
      BlocProvider.of<GetTeamMembersBloc>(context)
          .add(FetchSubordinatesList(supervisorId: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Column(
        children: [
          _buildSelectionContainer(),
          const SizedBox(height: 8),
          BlocBuilder<GetPartnersBloc, GetPartnersState>(
            builder: (_, state) => _buildDropdown<Partner>(
              'partner',
              state is PartnersLoaded ? state.partners : [],
              'Select Partner',
              visible: _selectionType == 'partner',
            ),
          ),
          BlocBuilder<GetTeamMembersBloc, GetTeamMembersState>(
            builder: (_, state) => _buildDropdown<TeamMember>(
              'teamMember_0',
              state is TeamMembersHierarchyLoaded ? state.topLevelMembers : [],
              'Select Team Member',
              visible: _selectionType == 'team_member',
            ),
          ),
          BlocBuilder<GetTeamMembersBloc, GetTeamMembersState>(
            builder: (_, state) {
              if (state is TeamMembersHierarchyLoaded) {
                return Column(
                  children: [
                    ..._buildSubordinateDropdowns(state.subordinates),
                  ],
                );
              }
              return Container();
            },
          ),
          _buildSalesInspectionSection(),
          const SizedBox(height: 8),
          _buildDropdown<String>(
              'fiscalYear', _fiscalYears, 'Select Fiscal Year'),
          const SizedBox(height: 8),
          _buildDropdown<String>('period', _periods, 'Select Period'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              loggy.debug('Submit button pressed');
            },
            style: Theme.of(context).filledButtonTheme.style,
            child: CustomText.labelSmall('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: _amberColor,
        borderRadius: _borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.titleSmall('Please select Partner or Team Member'),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              _buildRadioListTile('Partner', 'partner'),
              _buildRadioListTile('Team Member/Partner', 'team_member'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(String title, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: _selectionType,
            onChanged: (value) => _updateSelection('value', value),
            activeColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => _updateSelection('value', value),
              child: CustomText.labelSmall(title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberDropdown(
      int level, List<TeamMember>? items, String hint,
      {bool visible = true}) {
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: RepaintBoundary(
        child: ButtonTheme(
          alignedDropdown: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: DropdownButtonFormField<String>(
              key: ValueKey('dropdown_$level'),
              value: level < _teamMemberSelections.length
                  ? _teamMemberSelections[level]
                  : null,
              hint: CustomText.bodyMedium(hint),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
              items: items!
                  .map((item) => DropdownMenuItem(
                        key: ValueKey(item.id),
                        value: item.id,
                        child: CustomText.bodyMedium(item.name),
                      ))
                  .toList(),
              onChanged: (value) {
                _updateTeamMemberSelection(level, value);
                _unfocusAll();
              },
              borderRadius: _borderRadius,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String key, List<T>? items, String hint,
      {bool visible = true}) {
    if (key.startsWith('teamMember_')) {
      int level = int.parse(key.split('_')[1]);
      return _buildTeamMemberDropdown(level, items as List<TeamMember>?, hint,
          visible: visible);
    }

    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<dynamic>(
          value: _otherSelections[key],
          hint: CustomText.bodyMedium(hint),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            isDense: true,
          ),
          items: items
              ?.map((item) => DropdownMenuItem(
                    value: item is Partner ? item.id : item,
                    child: item is Partner
                        ? CustomText.bodyMedium(item.name)
                        : CustomText.bodyMedium(item as String),
                  ))
              .toList(),
          onChanged: (value) {
            _updateSelection(key, value);
            _unfocusAll();
          },
          borderRadius: _borderRadius,
          focusNode: _focusNodes[key],
        ),
      ),
    );
  }

  List<Widget> _buildSubordinateDropdowns(
      Map<String, List<TeamMember>?>? subordinates) {
    List<Widget> dropdowns = [];
    String? currentId =
        _teamMemberSelections.isNotEmpty ? _teamMemberSelections[0] : null;
    int level = 1;

    while (currentId != null && subordinates!.containsKey(currentId)) {
      final subordinateList = subordinates[currentId]!;

      if (subordinateList.isNotEmpty) {
        dropdowns.add(
          RepaintBoundary(
            child: _buildDropdown<TeamMember>(
              'teamMember_$level',
              subordinateList,
              'Select Team Member',
              visible: true,
            ),
          ),
        );
      }

      if (level < _teamMemberSelections.length) {
        currentId = _teamMemberSelections[level];
      } else {
        break;
      }
      level++;
    }

    return dropdowns;
  }

  Widget _buildSalesInspectionSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: _amberColor,
              borderRadius: _borderRadius,
            ),
            child: CustomText.titleSmall(
              'Sales inspection for year/period:',
            ),
          ),
        ),
      ],
    );
  }
}
