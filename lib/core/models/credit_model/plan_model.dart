class PlanModel {
  int? id;
  String? title;
  String? description;
  double? price;
  bool? isMonthly;
  bool? highlight;
  int? credit;
  List<FeaturesModel>? features;
  bool? active;

  PlanModel(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.isMonthly,
      this.highlight,
      this.credit,
      this.features,
      this.active});

  PlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    isMonthly = json['is_monthly'];
    highlight = json['highlight'];
    credit = json['credit'];
    if (json['features'] != null) {
      features = <FeaturesModel>[];
      json['features'].forEach((v) {
        features!.add(FeaturesModel.fromJson(v));
      });
    }
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['is_monthly'] = isMonthly;
    data['highlight'] = highlight;
    data['credit'] = credit;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['active'] = active;
    return data;
  }
}

class FeaturesModel {
  String? title;
  String? description;

  FeaturesModel({this.title, this.description});

  FeaturesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
