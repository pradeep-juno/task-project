import 'package:cloud_firestore/cloud_firestore.dart';

class PositionModel {
  String positionId;
  String positionName;
  DateTime positionCreatedAt;
  DateTime? positionUpdatedAt;

  // Constructor
  PositionModel(
      {required this.positionId,
      required this.positionName,
      required this.positionCreatedAt,
      this.positionUpdatedAt});

  // Factory method to create an instance from a map
  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(
      positionId: map['positionId'] ?? '',
      positionName: map['positionName'] ?? '',
      positionCreatedAt: (map['positionCreatedAt'] as Timestamp).toDate(),
      positionUpdatedAt: (map['positionUpdatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'positionId': positionId,
      'positionName': positionName,
      'positionCreatedAt': Timestamp.fromDate(positionCreatedAt),
      'positionUpdatedAt': positionUpdatedAt != null
          ? Timestamp.fromDate(positionUpdatedAt!)
          : null,
    };
  }

  // Override toString method
  @override
  String toString() {
    return 'PositionModel(positionId: $positionId, positionName: $positionName, positionCreatedAt: $positionCreatedAt,'
        'positionUpdatedAt: $positionUpdatedAt)';
  }
}
