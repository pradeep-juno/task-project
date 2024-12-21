import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  String deptId;
  String deptName;
  DateTime deptCreatedAt;
  DateTime? deptUpdatedAt;

  // Constructor
  DepartmentModel({
    required this.deptId,
    required this.deptName,
    required this.deptCreatedAt,
    this.deptUpdatedAt,
  });

  // Factory method to create an instance from a map
  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      deptId: map['deptId'] ?? '',
      deptName: map['deptName'] ?? '',
      deptCreatedAt:
          (map['deptCreatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deptUpdatedAt: (map['deptUpdatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'deptId': deptId,
      'deptName': deptName,
      'deptCreatedAt': Timestamp.fromDate(deptCreatedAt),
      'deptUpdatedAt':
          deptUpdatedAt != null ? Timestamp.fromDate(deptUpdatedAt!) : null,
    };
  }

  // Override toString method
  @override
  String toString() {
    return 'DepartmentModel(deptId: $deptId, deptName: $deptName, deptCreatedAt: $deptCreatedAt, '
        'deptUpdatedAt: $deptUpdatedAt)';
  }
}
