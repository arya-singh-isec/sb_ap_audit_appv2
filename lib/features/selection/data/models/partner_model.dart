import '../../domain/entities/partner.dart';

class PartnerModel extends Partner {
  const PartnerModel({required super.id, required super.name});

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(id: json['SubBrokerCode'], name: json['SubBrokerName']);
  }

  Map<String, dynamic> toJson() {
    return {"SubBrokerCode": id, "SubBrokerName": name};
  }
}
