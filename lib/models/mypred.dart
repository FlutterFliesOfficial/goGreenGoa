import 'dart:ffi';

class Pred {
  Int id;

  List<double> prediction;

  Pred({required this.id, required this.prediction});

  Pred.fromJson(Map<String, dynamic> json)
      : id = json['id'] as Int,
        prediction = json['predictions'] as List<double>;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prediction': prediction,
    };
  }

  Pred copyWith({
    Int? id,
    String? tags,
    String? description,
    String? websiteName,
  }) {
    return Pred(
      id: id ?? this.id,
      prediction: prediction ?? this.prediction,
    );
  }
}
