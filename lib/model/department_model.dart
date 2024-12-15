import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  String deptId;
  String deptName;
  DateTime deptCreatedAt;

  // Constructor
  DepartmentModel({
    required this.deptId,
    required this.deptName,
    required this.deptCreatedAt,
  });

  // Factory method to create an instance from a map
  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      deptId: map['deptId'] ?? '',
      deptName: map['deptName'] ?? '',
      deptCreatedAt: (map['deptCreatedAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'deptId': deptId,
      'deptName': deptName,
      'deptCreatedAt': Timestamp.fromDate(deptCreatedAt),
    };
  }

  // Override toString method
  @override
  String toString() {
    return 'DepartmentModel(deptId: $deptId, deptName: $deptName, deptCreatedAt: $deptCreatedAt)';
  }
}
