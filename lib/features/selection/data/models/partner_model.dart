import '../../domain/entities/partner.dart';

class PartnerModel extends Partner {
  const PartnerModel({required super.id, required super.name});

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(id: json['data']['id'], name: json['data']['name']);
  }

  Map<String, dynamic> toJson() {
    return {id: id, name: name};
  }
}
