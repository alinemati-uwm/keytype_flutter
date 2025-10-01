import 'package:json_annotation/json_annotation.dart';

part 'payment_response_model.g.dart';

@JsonSerializable()
class PaymentResponseModel {
  final String? url;
  final double? amount;

  PaymentResponseModel({
    this.url,
    this.amount,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseModelToJson(this);
}
