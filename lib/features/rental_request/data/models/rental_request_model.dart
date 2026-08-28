import '../../../property/data/models/property_model.dart';
import '../../../../shared/enums/rental_status.dart';

class RentalRequestModel {
  const RentalRequestModel({
    required this.id,
    this.propertyId,
    this.propertyTitle,
    this.propertyCity,
    this.tenantId,
    this.status,
    this.message,
    this.requestedAt,
    this.decisionAt,
    this.decisionNote,
    this.property,
  });

  factory RentalRequestModel.fromJson(Map<String, dynamic> json) {
    final rawStatus =
        json['status']?.toString() ?? json['statusName']?.toString();
    final property = json['property'];
    return RentalRequestModel(
      id: json['id']?.toString() ?? '',
      propertyId: json['propertyId']?.toString(),
      propertyTitle: json['propertyTitle']?.toString(),
      propertyCity: json['propertyCity']?.toString(),
      tenantId: json['tenantId']?.toString(),
      status: RentalStatus.fromName(rawStatus),
      message: json['message']?.toString(),
      requestedAt: json['requestedAt']?.toString(),
      decisionAt: json['decisionAt']?.toString(),
      decisionNote: json['decisionNote']?.toString(),
      property: property is Map<String, dynamic>
          ? PropertyModel.fromJson(property)
          : null,
    );
  }

  final String id;
  final String? propertyId;
  final String? propertyTitle;
  final String? propertyCity;
  final String? tenantId;
  final RentalStatus? status;
  final String? message;
  final String? requestedAt;
  final String? decisionAt;
  final String? decisionNote;
  final PropertyModel? property;
}
