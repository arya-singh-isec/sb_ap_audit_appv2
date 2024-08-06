import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_fiscal_year/bloc.dart';

import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/partner.dart';
import '../../domain/entities/team_member.dart';
import '../blocs/get_partners/bloc.dart';
import '../blocs/get_team_members/bloc.dart';
import '../blocs/submit_selection/bloc.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> with UiLoggy {
  static const EdgeInsets _padding = EdgeInsets.all(16);
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(8));

  // constants
  final List<String> _fiscalPeriods = ['First half', 'Second half'];

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
      // BlocProvider.of<GetTeamMembersBloc>(context).add(FetchTeamMembersList());
      // Get Fiscal Year List
      BlocProvider.of<GetFiscalYearBloc>(context).add(FetchFiscalYearList());
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

  void _updateSelection(String key, String? newValue) {
    if (key.startsWith('teamMember_')) {
      int level = int.parse(key.split('_')[1]);
      context
          .read<SelectionBloc>()
          .add(TeamMemberSelected(newValue, level: level));
      if (newValue != null) {
        context
            .read<GetTeamMembersBloc>()
            .add(FetchSubordinatesList(supervisorId: newValue));
      }
    } else if (key == 'partner') {
      context.read<SelectionBloc>().add(PartnerSelected(newValue!));
    } else if (key == 'fiscalYear') {
      context.read<SelectionBloc>().add(FiscalYearSelected(newValue!));
    } else if (key == 'fiscalPeriod') {
      context.read<SelectionBloc>().add(FiscalPeriodSelected(newValue!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      behavior: HitTestBehavior.opaque,
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, state) => Padding(
          padding: _padding,
          child: Column(
            children: [
              _buildSelectionContainer(state),
              const SizedBox(height: 8),
              BlocBuilder<GetPartnersBloc, GetPartnersState>(
                builder: (_, partnersState) => _buildDropdown<Partner>(
                  'partner',
                  partnersState is PartnersLoaded
                      ? partnersState.partners
                      : null,
                  'Select Partner',
                  state.selectedPartner,
                  visible: state.selectionType == SelectionType.partner,
                ),
              ),
              BlocBuilder<GetTeamMembersBloc, GetTeamMembersState>(
                builder: (_, teamMembersState) => _buildDropdown<TeamMember>(
                  'teamMember_0',
                  teamMembersState is TeamMembersHierarchyLoaded
                      ? teamMembersState.topLevelMembers
                      : [],
                  'Select Team Member',
                  state.teamMemberIds!.isNotEmpty
                      ? state.teamMemberIds!.first
                      : null,
                  visible: state.selectionType == SelectionType.teamMember,
                ),
              ),
              BlocBuilder<GetTeamMembersBloc, GetTeamMembersState>(
                builder: (_, teamMembersState) {
                  if (teamMembersState is TeamMembersHierarchyLoaded) {
                    return Column(
                      children: [
                        ..._buildSubordinateDropdowns(
                            state, teamMembersState.subordinates),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              _buildSalesInspectionSection(),
              const SizedBox(height: 8),
              BlocBuilder<GetFiscalYearBloc, GetFiscalYearState>(
                builder: (context, fiscalYearState) => _buildDropdown<String>(
                  'fiscalYear',
                  fiscalYearState is FiscalYearDataLoaded
                      ? fiscalYearState.fiscalYears
                      : null,
                  'Select Fiscal Year',
                  state.fiscalYear,
                ),
              ),
              _buildDropdown<String>('period', _fiscalPeriods, 'Select Period',
                  state.fiscalPeriod),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  loggy.debug('Submit button pressed');
                  context.read<SelectionBloc>().add(SubmitSelection());
                },
                style: Theme.of(context).filledButtonTheme.style,
                child: CustomText.labelSmall(
                  'Submit',
                  textColor: TextColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionContainer(SelectionState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: _borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.titleSmall('Please select Partner or Team Member'),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              _buildRadioListTile('Partner', SelectionType.partner, state),
              _buildRadioListTile(
                  'Team Member/Partner', SelectionType.teamMember, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(
      String title, SelectionType value, SelectionState state) {
    void updateSelectionType(value) {
      context
          .read<SelectionBloc>()
          .add(SelectionTypeChanged(selectionType: value));
    }

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value.toString(),
            groupValue: state.selectionType.toString(),
            onChanged: (_) => updateSelectionType(value),
            activeColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => updateSelectionType(value),
              child: CustomText.labelSmall(title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberDropdown(
      String key, List<TeamMember>? items, String hint, String? value,
      {bool visible = true}) {
    int level = int.parse(key.split('_')[1]);
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: RepaintBoundary(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            menuMaxHeight: 200.0,
            key: ValueKey('dropdown_$level'),
            value: value,
            hint: CustomText.bodyMedium(hint),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
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
              _updateSelection(key, value);
            },
            borderRadius: _borderRadius,
            padding: const EdgeInsets.only(bottom: 8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      String key, List<T>? items, String hint, String? value,
      {bool visible = true}) {
    if (key.startsWith('teamMember_')) {
      return _buildTeamMemberDropdown(
          key, items as List<TeamMember>?, hint, value,
          visible: visible);
    }

    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<dynamic>(
          isExpanded: true,
          menuMaxHeight: 200.0,
          value: value,
          hint: CustomText.bodyMedium(hint),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
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
          },
          borderRadius: _borderRadius,
          focusNode: _focusNodes[key],
          padding: const EdgeInsets.only(bottom: 8.0),
        ),
      ),
    );
  }

  List<Widget> _buildSubordinateDropdowns(
      SelectionState state, Map<String, List<TeamMember>?>? subordinates) {
    List<Widget> dropdowns = [];
    String? currentId =
        state.teamMemberIds!.isNotEmpty ? state.teamMemberIds!.first : null;
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
              level < state.teamMemberIds!.length
                  ? state.teamMemberIds![level]
                  : null,
            ),
          ),
        );
      }

      if (level < state.teamMemberIds!.length) {
        currentId = state.teamMemberIds![level];
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
              color: Colors.amber,
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
