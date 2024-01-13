class BmiEntryModel {
  final double weight;
  final double height;
  final int age;
  final double bmi;
  final int timestamp;
  final String bmiCategory; // New field for BMI category

  BmiEntryModel({
    required this.weight,
    required this.height,
    required this.age,
    required this.bmi,
    required this.timestamp,
    required this.bmiCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'bmi': bmi,
      'timestamp': timestamp,
      'bmiCategory': bmiCategory, // Include BMI category in the map
    };
  }

  factory BmiEntryModel.fromJson(jsonData) {
    return BmiEntryModel(
      weight: jsonData['weight'],
      height: jsonData['height'],
      age: jsonData['age'],
      bmi: jsonData['bmi'],
      timestamp: jsonData['timestamp'],
      bmiCategory: jsonData['bmiCategory'],
    );
  }

  BmiEntryModel copyWith({
    double? weight,
    double? height,
    int? age,
    double? bmi,
    int? timestamp,
    String? bmiCategory,
  }) {
    return BmiEntryModel(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      bmi: bmi ?? this.bmi,
      timestamp: timestamp ?? this.timestamp,
      bmiCategory: bmiCategory ?? this.bmiCategory,
    );
  }
}
