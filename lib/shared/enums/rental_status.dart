enum RentalStatus {
  pending,
  approved,
  rejected,
  cancelled,
  expired;

  static RentalStatus? fromName(String? name) {
    if (name == null) {
      return null;
    }
    for (final status in RentalStatus.values) {
      if (status.name == name.toLowerCase()) {
        return status;
      }
    }
    return null;
  }

  String get label {
    switch (this) {
      case RentalStatus.pending:
        return 'Pending';
      case RentalStatus.approved:
        return 'Approved';
      case RentalStatus.rejected:
        return 'Rejected';
      case RentalStatus.cancelled:
        return 'Cancelled';
      case RentalStatus.expired:
        return 'Expired';
    }
  }
}
