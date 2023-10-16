class UsersModel {
  int id = 0;
  String name = '';

  UsersModel({this.id = 0, this.name = ''});

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }
}
