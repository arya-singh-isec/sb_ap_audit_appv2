import 'package:equatable/equatable.dart';

class Partner extends Equatable {
  final String id;
  final String name;

  const Partner({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
