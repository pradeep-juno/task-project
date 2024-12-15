import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel {
  String staffId;
  String staffName;
  String staffJoiningDate;
  String staffMobileNumber;
  String staffPassword;
  String staffDob;
  String staffMobileNumber2;
  String staffAddress;
  DateTime staffCreatedAt;

  // Constructor
  StaffModel({
    required this.staffId,
    required this.staffName,
    required this.staffJoiningDate,
    required this.staffMobileNumber,
    required this.staffPassword,
    required this.staffDob,
    required this.staffMobileNumber2,
    required this.staffAddress,
    required this.staffCreatedAt,
  });

  // Factory constructor to create an instance from a map
  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      staffId: map['staffId'],
      staffName: map['staffName'],
      staffJoiningDate: map['staffJoiningDate'],
      staffMobileNumber: map['staffMobileNumber'],
      staffPassword: map['staffPassword'],
      staffDob: map['staffDob'],
      staffMobileNumber2: map['staffMobileNumber2'],
      staffAddress: map['staffAddress'],
      staffCreatedAt: (map['staffCreatedAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'staffId': staffId,
      'staffName': staffName,
      'staffJoiningDate': staffJoiningDate,
      'staffMobileNumber': staffMobileNumber,
      'staffPassword': staffPassword,
      'staffDob': staffDob,
      'staffMobileNumber2': staffMobileNumber2,
      'staffAddress': staffAddress,
      'staffCreatedAt': Timestamp.fromDate(staffCreatedAt),
    };
  }

  // toString method for easy string representation
  @override
  String toString() {
    return 'StaffModel(staffId: $staffId, staffName: $staffName, staffJoiningDate: $staffJoiningDate, '
        'staffMobileNumber: $staffMobileNumber, staffPassword: $staffPassword, '
        'staffDob: $staffDob, staffMobileNumber2: $staffMobileNumber2, staffAddress: $staffAddress, '
        'staffCreatedAt: $staffCreatedAt)';
  }
}
