// lib/presentation/pages/record_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
import '../../data/repository/record_repository_impl.dart';
import '../../domain/usecases/get_record_data.dart';
import '../blocs/record_bloc.dart';
import '../widget/record_card.dart';
import 'rejected_record_page.dart';






class RecordListPage extends StatelessWidget {
  const RecordListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recordRepository = RecordRepositoryImpl();
    final getRecords = GetRecords(recordRepository);

    return BlocProvider(
      create: (context) => RecordCubit(getRecords: getRecords)..fetchRecords(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Summary'),
        ),
        body: BlocBuilder<RecordCubit, RecordState>(
          builder: (context, state) {
            if (state is RecordInitial) {
              return Center(child: Text('Please wait while we fetch data...'));
            } else if (state is RecordLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RecordLoaded) {

              return  ListView.builder(
        itemCount: state.records.length,
        itemBuilder: (context, index) {
          final record = state.records[index];
          return GestureDetector(
            onTap: () {
              if (record.status.contains('REJECTED')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RejectedRecordPage(record: record),
                  ),
                );
              }
            },
            child: RecordCard(record: record),
          );
        },
      );
              // return ListView.builder(
              //   itemCount: state.records.length,
              //   itemBuilder: (context, index) {
              //     return RecordCard(record: state.records[index]);
              //   },
              // );
            } else if (state is RecordError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}
