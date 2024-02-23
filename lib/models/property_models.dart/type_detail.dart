class TypeDetail {
  final int typeDetailId;
  final String typeDetailName;


  TypeDetail({
    required this.typeDetailId,
    required this.typeDetailName,

  });

  TypeDetail.fromjson(Map<String, dynamic> json)
      : typeDetailId = json['id'],
        typeDetailName = json['name'];

}
