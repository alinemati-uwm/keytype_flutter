import 'package:json_annotation/json_annotation.dart';

import '../credit_model/plan_model.dart';
import '../credit_model/subscription_model.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? email;
  final String? username;
  final String? password;
  @JsonKey(name: 'password_confirm')
  final String? passwordConfirm;
  final String? id;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'date_joined')
  final String? dateJoined;
  @JsonKey(name: 'phone_number')
  final dynamic phoneNumber;
  final dynamic description;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;
  @JsonKey(name: 'profile_image')
  String? profileImage;
  final PlanModel? plan;
  final SubscriptionModel? subscription;

  UserModel({
    this.email,
    this.username,
    this.password,
    this.passwordConfirm,
    this.id,
    this.firstName,
    this.lastName,
    this.isActive,
    this.dateJoined,
    this.phoneNumber,
    this.description,
    this.isVerified,
    this.profileImage,
    this.plan,
    this.subscription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
