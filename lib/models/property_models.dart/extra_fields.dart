class ExtraFields {
  final String name;
  final dynamic value;

  ExtraFields({required this.name, this.value});
  ExtraFields.fromjson(Map<String, dynamic> json)
      : name = json['fieldname'],
        value = json['fieldvalue'];
}
