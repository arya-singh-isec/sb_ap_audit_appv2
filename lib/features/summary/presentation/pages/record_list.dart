// lib/presentation/pages/record_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sb_ap_audit_appv2/core/config/constants.dart';

import '../../data/repository/record_repository_impl.dart';
import '../../domain/usecases/get_record_data.dart';
import '../blocs/record_bloc.dart';
import '../widget/record_card.dart';

class RecordListPage extends StatelessWidget {
  const RecordListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recordRepository = RecordRepositoryImpl();
    final getRecords = GetRecords(recordRepository);

    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            RecordCubit(getRecords: getRecords)..fetchRecords(),
        child: BlocBuilder<RecordCubit, RecordState>(
          builder: (context, state) {
            if (state is RecordInitial) {
              return const Center(
                  child: Text('Please wait while we fetch data...'));
            } else if (state is RecordLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecordLoaded) {
              return ListView.builder(
                itemCount: state.records.length,
                itemBuilder: (context, index) {
                  final record = state.records[index];
                  return GestureDetector(
                    onTap: () {
                      if (record.status.contains('REJECTED')) {
                        context.goNamed(AppRoutes.rejectedRecord,
                            extra: record);
                      }
                    },
                    child: RecordCard(record: record),
                  );
                },
              );
            } else if (state is RecordError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}
