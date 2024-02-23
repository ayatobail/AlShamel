// For property details values

class DetailsValues {
  final String? name;
  final dynamic value;

  DetailsValues({required this.name, this.value});

  DetailsValues.fromjson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];
}
