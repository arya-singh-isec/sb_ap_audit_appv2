import 'package:flutter/material.dart';

import '../../../../core/app_bar.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  static const Color _amberColor = Colors.amber;
  static const EdgeInsets _padding = EdgeInsets.all(16);
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(8));

  static const List<String> _partners = ['Partner A', 'Partner B', 'Partner C'];
  static const Map<String, List<String>> _teams = {
    'TeamMember A': ['Bah Bah black sheep', 'Sprinter'],
    'TeamMember B': ['Tom&Jerry', 'Ben10'],
  };
  static const List<String> _teamMembers = ['TeamMember A', 'TeamMember B'];
  static const List<String> _fiscalYears = ['FY 2024-2025', 'FY 2023-2024'];
  static const List<String> _periods = ['First half', 'Second half'];

  final Map<String, String?> _selections = {
    'value': null,
    'partner': null,
    'teamMember': null,
    'teamMember2': null,
    'fiscalYear': null,
    'period': null,
  };

  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    // Create a FocusNode for each dropdown
    for (var key in [
      'partner',
      'teamMember',
      'teamMember2',
      'fiscalYear',
      'period'
    ]) {
      _focusNodes[key] = FocusNode();
    }
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
    setState(() {
      _selections[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      child: Padding(
        padding: _padding,
        child: Column(
          children: [
            _buildSelectionContainer(),
            const SizedBox(height: 8),
            _buildDropdown(
              'partner',
              _partners,
              'Select Partner',
              visible: _selections['value'] == 'partner',
            ),
            _buildDropdown(
              'teamMember',
              _teamMembers,
              'Select Team Member',
              visible: _selections['value'] == 'team_member',
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              'teamMember2',
              _teams[_selections['teamMember']] ?? [],
              'Select Team Member',
              visible: _selections['value'] == 'team_member' &&
                  _selections['teamMember'] != null,
            ),
            const SizedBox(height: 20),
            _buildSalesInspectionSection(),
            const SizedBox(height: 8),
            _buildDropdown('fiscalYear', _fiscalYears, 'Select Fiscal Year'),
            const SizedBox(height: 8),
            _buildDropdown('period', _periods, 'Select Period'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppBarProvider.of(context).titleNotifier.value =
                    'Bah Bah Black Sheep';
              },
              style: ElevatedButton.styleFrom(
                shape:
                    const RoundedRectangleBorder(borderRadius: _borderRadius),
                backgroundColor: _amberColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
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
          const Text(
            'Please select Partner or Team Member',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
              height: 8), // Add a small gap between the text and radio buttons
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
            groupValue: _selections['value'],
            onChanged: (value) => _updateSelection('value', value),
            activeColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => _updateSelection('value', value),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String key, List<String> items, String hint,
      {bool visible = true}) {
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          value: _selections[key],
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            isDense: true,
          ),
          items: items
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) {
            _updateSelection(key, value);
            _unfocusAll();
          },
          borderRadius: _borderRadius,
          isExpanded: true, // Ensure the button uses the full width
          icon: const Icon(
              Icons.arrow_drop_down), // Optional: customize the dropdown icon
          iconSize: 24, // Optional: adjust icon size
          elevation: 16, // Optional: adjust the elevation of the dropdown menu
          style: const TextStyle(color: Colors.black, fontSize: 16),
          focusNode: _focusNodes[key], // Optional: adjust text style
        ),
      ),
    );
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
            child: const Text(
              'Sales inspection for year/period:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
