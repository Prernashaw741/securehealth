class DocumentModel {
  int? id;
  String? documentName;
  String? document;
  String? createdAt;
  bool? isShared;
  int? uploadedBy;
  List<int>? sharedWith;

  DocumentModel(
      {this.id,
      this.documentName,
      this.document,
      this.createdAt,
      this.isShared,
      this.uploadedBy,
      this.sharedWith});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentName = json['document_name'];
    document = json['document'];
    createdAt = json['created_at'];
    isShared = json['is_shared'];
    uploadedBy = json['uploaded_by'];
    sharedWith = json['shared_with'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_name'] = this.documentName;
    data['document'] = this.document;
    data['created_at'] = this.createdAt;
    data['is_shared'] = this.isShared;
    data['uploaded_by'] = this.uploadedBy;
    data['shared_with'] = this.sharedWith;
    return data;
  }
}
