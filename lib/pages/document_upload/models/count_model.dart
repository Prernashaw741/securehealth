class CountModel {
  String? message;
  int? yourDocuments;
  int? sharedWithYou;
  int? sharedByYou;

  CountModel(
      {this.message, this.yourDocuments, this.sharedWithYou, this.sharedByYou});

  CountModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    yourDocuments = json['your_documents'];
    sharedWithYou = json['shared_with_you'];
    sharedByYou = json['shared_by_you'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['your_documents'] = this.yourDocuments;
    data['shared_with_you'] = this.sharedWithYou;
    data['shared_by_you'] = this.sharedByYou;
    return data;
  }
}
