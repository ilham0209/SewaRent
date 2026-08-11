import '../../../../features/property/data/models/property_model.dart';
import '../../../../shared/enums/rental_status.dart';

class RentalRequestModel {
  const RentalRequestModel({
    required this.id,
    required this.propertyId,
    this.status,
    this.message,
    this.requestedAt,
    this.updatedAt,
    this.decisionAt,
    this.decisionNote,
    this.property,
  });

  factory RentalRequestModel.fromJson(Map<String, dynamic> json) {
    final rawStatus =
        json['status']?.toString() ?? json['statusName']?.toString();
    final property = json['property'];
    return RentalRequestModel(
      id: (json['id'] as num).toInt(),
      propertyId: (json['propertyId'] as num?)?.toInt() ?? 0,
      status: RentalStatus.fromName(rawStatus),
      message: json['message']?.toString(),
      requestedAt: json['requestedAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      decisionAt: json['decisionAt']?.toString(),
      decisionNote: json['decisionNote']?.toString(),
      property: property is Map<String, dynamic>
          ? PropertyModel.fromJson(property)
          : null,
    );
  }

  final int id;
  final int propertyId;
  final RentalStatus? status;
  final String? message;
  final String? requestedAt;
  final String? updatedAt;
  final String? decisionAt;
  final String? decisionNote;
  final PropertyModel? property;
}
