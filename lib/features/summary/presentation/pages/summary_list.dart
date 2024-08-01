import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sb_ap_audit_appv2/core/config/constants.dart';
import '../blocs/summary_bloc.dart';
import '../widget/summary_card.dart';

class SummaryListPage extends StatefulWidget {
  const SummaryListPage({super.key});

  @override
  State<SummaryListPage> createState() => _SummaryListPageState();
}

class _SummaryListPageState extends State<SummaryListPage> {
  @override
  void initState() {
   
    BlocProvider.of<SummaryCubit>(context).fetchSummarys();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      BlocBuilder<SummaryCubit, SummaryState>(
          builder: (context, state) {
            if (state is SummaryInitial) {
              return const Center(child: Text('Please wait while we fetch data...'));
            } else if (state is SummaryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SummaryLoaded) {
              final records = state.records.fold(
                (failure) => null, 
                (records) => records, 
              );

              if (records == null || records.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Trigger a refresh by calling fetchSummarys()
                  BlocProvider.of<SummaryCubit>(context).fetchSummarys();
                },
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return GestureDetector(
                      onTap: () {
                        if (record.auditStatus.contains('REJECTED')) {
                          context.goNamed(AppRoutes.rejectedSummary, extra: record);
                        }
                      },
                      child: SummaryCard(record: record),
                    );
                  },
                ),
              );
            } else if (state is SummaryError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
      
      
    )
    );
  }
}
