

import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  final bool? active;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'daily_bonus')
  final num? dailyBonus;
  @JsonKey(name: 'total_referral_bonus')
  final num? totalReferralBonus;
  @JsonKey(name: 'referral_bonus')
  final num? referralBonus;
  final num? credit;
  final bool? annual;
  final num? price;
  @JsonKey(name: 'base_daily_bonus')
  final num? baseDailyBonus;
  @JsonKey(name: 'base_credit')
  final num? baseCredit;
  @JsonKey(name: 'total_credit')
  final num? totalCredit;
  final String? status;

  SubscriptionModel({
    this.active,
    this.startDate,
    this.endDate,
    this.dailyBonus,
    this.totalReferralBonus,
    this.referralBonus,
    this.credit,
    this.annual,
    this.price,
    this.baseDailyBonus,
    this.baseCredit,
    this.totalCredit,
    this.status,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
