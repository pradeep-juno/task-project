import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel {
  String staffId;
  String staffName;
  String staffJoiningDate;
  String staffMobileNumber;
  String staffPassword;
  String deptId;
  String deptName;
  String positionId;
  String positionName;
  String staffDob;
  String staffMobileNumberTwo;
  String staffAddress;
  DateTime staffCreatedAt;
  String? createdById;
  String? createdByName;
  DateTime? staffUpdatedAt;

  // Constructor
  StaffModel({
    required this.staffId,
    required this.staffName,
    required this.staffJoiningDate,
    required this.staffMobileNumber,
    required this.staffPassword,
    required this.deptId,
    required this.deptName,
    required this.positionId,
    required this.positionName,
    required this.staffDob,
    required this.staffMobileNumberTwo,
    required this.staffAddress,
    required this.staffCreatedAt,
    this.createdById,
    this.createdByName,
    this.staffUpdatedAt,
  });

  // Factory constructor to create an instance from a map
  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      staffId: map['staffId'],
      staffName: map['staffName'],
      staffJoiningDate: map['staffJoiningDate'],
      staffMobileNumber: map['staffMobileNumber'],
      staffPassword: map['staffPassword'],
      deptId: map['deptId'],
      deptName: map['deptName'],
      positionId: map['positionId'],
      positionName: map['positionName'],
      staffDob: map['staffDob'],
      staffMobileNumberTwo: map['staffMobileNumberTwo'],
      staffAddress: map['staffAddress'],
      staffCreatedAt: (map['staffCreatedAt'] as Timestamp).toDate(),
      createdById: map['createdById'],
      createdByName: map['createdByName'],
    );
  }

  // Method to convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'staffId': staffId,
      'staffName': staffName,
      'staffJoiningDate': staffJoiningDate,
      'staffMobileNumber': staffMobileNumber,
      'staffPassword': staffPassword,
      'deptId': deptId,
      'deptName': deptName,
      'positionId': positionId,
      'positionName': positionName,
      'staffDob': staffDob,
      'staffMobileNumberTwo': staffMobileNumberTwo,
      'staffAddress': staffAddress,
      'staffCreatedAt': Timestamp.fromDate(staffCreatedAt),
      'createdById': createdById,
      'createdByName': createdByName,
    };
  }

  // toString method for easy string representation
  @override
  String toString() {
    return 'StaffModel(staffId: $staffId, staffName: $staffName, staffJoiningDate: $staffJoiningDate, '
        'staffMobileNumber: $staffMobileNumber, staffPassword: $staffPassword, '
        'deptId: $deptId, deptName: $deptName, positionId: $positionId, positionName: $positionName, '
        'staffDob: $staffDob, staffMobileNumberTwo: $staffMobileNumberTwo, staffAddress: $staffAddress, '
        'staffCreatedAt: $staffCreatedAt, createdById: $createdById, createdByName: $createdByName)';
  }
}
