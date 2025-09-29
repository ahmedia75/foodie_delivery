// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class LoginResponseModel {
  String? message;
  DeliveryAgentModel? data;
  LoginResponseModel({this.message, this.data});

  LoginResponseModel copyWith({String? message, DeliveryAgentModel? data}) {
    return LoginResponseModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (message != null) {
      result.addAll({'message': message});
    }
    if (data != null) {
      result.addAll({'data': data!.toMap()});
    }

    return result;
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      message: map['message'],
      data:
          map['data'] != null ? DeliveryAgentModel.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source));

  @override
  String toString() => 'LoginResponseModel(message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginResponseModel &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class DeliveryAgentResponseModel {
  bool? success;
  DeliveryAgentModel? data;
  String? error;

  DeliveryAgentResponseModel({this.success, this.data, this.error});

  DeliveryAgentResponseModel copyWith({
    bool? success,
    DeliveryAgentModel? data,
    String? error,
  }) {
    return DeliveryAgentResponseModel(
      success: success ?? this.success,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (success != null) {
      result.addAll({'success': success});
    }
    if (data != null) {
      result.addAll({'data': data!.toMap()});
    }
    if (error != null) {
      result.addAll({'error': error});
    }

    return result;
  }

  factory DeliveryAgentResponseModel.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentResponseModel(
      success: map['success'] != null ? map['success'] as bool : null,
      data:
          map['data'] != null ? DeliveryAgentModel.fromMap(map['data']) : null,
      error: map['error'] != null ? map['error'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAgentResponseModel.fromJson(String source) =>
      DeliveryAgentResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DeliveryAgentResponseModel(success: $success, data: $data, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeliveryAgentResponseModel &&
        other.success == success &&
        other.data == data &&
        other.error == error;
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode ^ error.hashCode;
}

class DeliveryAgentModel {
  String? id;
  String? name;
  String? phone;
  DateTime? dateOfBirth;
  String? address;
  String? vehicleNumber;
  String? vehicleModel;
  String? vehicleType;
  String? licenseNumber;
  BranchModel? branchId;
  bool? isAvailable;
  bool? status;
  int? totalDeliveries;
  int? dailyDeliveries;
  List<String>? proofDocuments;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;
  String? deviceToken;
  String? devicePlatform;
  DateTime? lastDeliveryDate;
  DeliveryAgentModel({
    this.id,
    this.name,
    this.phone,
    this.dateOfBirth,
    this.address,
    this.vehicleNumber,
    this.vehicleModel,
    this.vehicleType,
    this.licenseNumber,
    this.branchId,
    this.isAvailable,
    this.status,
    this.totalDeliveries,
    this.dailyDeliveries,
    this.proofDocuments,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.deviceToken,
    this.devicePlatform,
    this.lastDeliveryDate,
  });

  DeliveryAgentModel copyWith({
    String? id,
    String? name,
    String? phone,
    DateTime? dateOfBirth,
    String? address,
    String? vehicleNumber,
    String? vehicleModel,
    String? vehicleType,
    String? licenseNumber,
    BranchModel? branchId,
    bool? isAvailable,
    bool? status,
    int? totalDeliveries,
    int? dailyDeliveries,
    List<String>? proofDocuments,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
    String? deviceToken,
    String? devicePlatform,
    DateTime? lastDeliveryDate,
  }) {
    return DeliveryAgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleType: vehicleType ?? this.vehicleType,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      branchId: branchId ?? this.branchId,
      isAvailable: isAvailable ?? this.isAvailable,
      status: status ?? this.status,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      dailyDeliveries: dailyDeliveries ?? this.dailyDeliveries,
      proofDocuments: proofDocuments ?? this.proofDocuments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
      deviceToken: deviceToken ?? this.deviceToken,
      devicePlatform: devicePlatform ?? this.devicePlatform,
      lastDeliveryDate: lastDeliveryDate ?? this.lastDeliveryDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'address': address,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'vehicleType': vehicleType,
      'licenseNumber': licenseNumber,
      'branchId': branchId?.toMap(),
      'isAvailable': isAvailable,
      'status': status,
      'totalDeliveries': totalDeliveries,
      'dailyDeliveries': dailyDeliveries,
      'proofDocuments': proofDocuments,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'token': token,
      'deviceToken': deviceToken,
      'devicePlatform': devicePlatform,
      'lastDeliveryDate': lastDeliveryDate?.millisecondsSinceEpoch,
    };
  }

  factory DeliveryAgentModel.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      dateOfBirth:
          map['dateOfBirth'] != null ? _parseDate(map['dateOfBirth']) : null,
      address: map['address'] != null ? map['address'] as String : null,
      vehicleNumber:
          map['vehicleNumber'] != null ? map['vehicleNumber'] as String : null,
      vehicleModel:
          map['vehicleModel'] != null ? map['vehicleModel'] as String : null,
      vehicleType:
          map['vehicleType'] != null ? map['vehicleType'] as String : null,
      licenseNumber:
          map['licenseNumber'] != null ? map['licenseNumber'] as String : null,
      branchId: map['branchId'] != null
          ? map['branchId'].runtimeType == String
              ? BranchModel(id: map['branchId'])
              : BranchModel.fromMap(map['branchId'] as Map<String, dynamic>)
          : null,
      isAvailable:
          map['isAvailable'] != null ? map['isAvailable'] as bool : null,
      status: map['status'] != null ? map['status'] as bool : null,
      totalDeliveries:
          map['totalDeliveries'] != null ? map['totalDeliveries'] as int : null,
      dailyDeliveries:
          map['dailyDeliveries'] != null ? map['dailyDeliveries'] as int : null,
      proofDocuments: map['proofDocuments'] != null
          ? List<String>.from((map['proofDocuments'] as List))
          : null,
      createdAt: map['createdAt'] != null ? _parseDate(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? _parseDate(map['updatedAt']) : null,
      token: map['token'] != null ? map['token'] as String : null,
      deviceToken:
          map['deviceToken'] != null ? map['deviceToken'] as String : null,
      devicePlatform: map['devicePlatform'] != null
          ? map['devicePlatform'] as String
          : null,
      lastDeliveryDate: map['lastDeliveryDate'] != null
          ? _parseDate(map['lastDeliveryDate'])
          : null,
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is String) {
      return DateTime.parse(date);
    } else if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    }
    return null;
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAgentModel.fromJson(String source) =>
      DeliveryAgentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryAgentModel(_id: $id, name: $name, phone: $phone, dateOfBirth: $dateOfBirth, address: $address, vehicleNumber: $vehicleNumber, vehicleModel: $vehicleModel, vehicleType: $vehicleType, licenseNumber: $licenseNumber, branchId: $branchId, isAvailable: $isAvailable, status: $status, totalDeliveries: $totalDeliveries, dailyDeliveries: $dailyDeliveries, proofDocuments: $proofDocuments, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, deviceToken: $deviceToken, devicePlatform: $devicePlatform, lastDeliveryDate: $lastDeliveryDate)';
  }

  @override
  bool operator ==(covariant DeliveryAgentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.dateOfBirth == dateOfBirth &&
        other.address == address &&
        other.vehicleNumber == vehicleNumber &&
        other.vehicleModel == vehicleModel &&
        other.vehicleType == vehicleType &&
        other.licenseNumber == licenseNumber &&
        other.branchId == branchId &&
        other.isAvailable == isAvailable &&
        other.status == status &&
        other.totalDeliveries == totalDeliveries &&
        other.dailyDeliveries == dailyDeliveries &&
        listEquals(other.proofDocuments, proofDocuments) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.token == token &&
        other.deviceToken == deviceToken &&
        other.devicePlatform == devicePlatform &&
        other.lastDeliveryDate == lastDeliveryDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        dateOfBirth.hashCode ^
        address.hashCode ^
        vehicleNumber.hashCode ^
        vehicleModel.hashCode ^
        vehicleType.hashCode ^
        licenseNumber.hashCode ^
        branchId.hashCode ^
        isAvailable.hashCode ^
        status.hashCode ^
        totalDeliveries.hashCode ^
        dailyDeliveries.hashCode ^
        proofDocuments.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        token.hashCode ^
        deviceToken.hashCode ^
        devicePlatform.hashCode ^
        lastDeliveryDate.hashCode;
  }
}

class BranchModel {
  String? id;
  String? name;
  int? resseqId;
  String? address;
  String? email;
  int? phone;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<double>? coordinates;

  BranchModel({
    this.id,
    this.name,
    this.resseqId,
    this.address,
    this.email,
    this.phone,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.coordinates,
  });

  BranchModel copyWith({
    String? id,
    String? name,
    int? resseqId,
    String? address,
    String? email,
    int? phone,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<double>? coordinates,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      resseqId: resseqId ?? this.resseqId,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'resseqId': resseqId,
      'address': address,
      'email': email,
      'phone': phone,
      'isActive': isActive,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'location': coordinates != null
          ? {'type': 'Point', 'coordinates': coordinates}
          : null,
    };
  }

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      resseqId: map['resseqId'] != null ? map['resseqId'] as int : null,
      address: map['address'] != null ? map['address'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as int : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      createdAt: map['createdAt'] != null ? _parseDate(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? _parseDate(map['updatedAt']) : null,
      coordinates:
          map['location'] != null && map['location']['coordinates'] != null
              ? List<double>.from(map['location']['coordinates'] as List)
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchModel.fromJson(String source) =>
      BranchModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BranchModel(id: $id, name: $name, resseqId: $resseqId, address: $address, email: $email, phone: $phone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, coordinates: $coordinates)';
  }

  @override
  bool operator ==(covariant BranchModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.resseqId == resseqId &&
        other.address == address &&
        other.email == email &&
        other.phone == phone &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.coordinates, coordinates);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        resseqId.hashCode ^
        address.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        coordinates.hashCode;
  }
}

DateTime? _parseDate(dynamic date) {
  if (date == null) return null;
  if (date is String) {
    return DateTime.parse(date);
  } else if (date is int) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  }
  return null;
}
