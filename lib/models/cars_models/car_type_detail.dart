class CarTypeDetail {
  final int? detailsid;
  final String? detailsname;


  CarTypeDetail({
    this.detailsid,
    this.detailsname,

  });

  CarTypeDetail.fromjson(Map<String, dynamic> json)
      : detailsid = json['id'],
        detailsname = json['name'];

}
