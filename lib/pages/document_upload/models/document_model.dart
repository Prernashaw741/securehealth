class DocumentModel {
  int? id;
  String? documentName;
  String? document;
  String? createdAt;

  DocumentModel({this.id, this.documentName, this.document, this.createdAt});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentName = json['document_name'];
    document = json['document'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_name'] = this.documentName;
    data['document'] = this.document;
    data['created_at'] = this.createdAt;
    return data;
  }
}
