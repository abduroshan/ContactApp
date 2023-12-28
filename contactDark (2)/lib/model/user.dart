class User {
  int? id;
  String? name;
  String? phone;
  String? image;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name!;
    mapping['phone'] = phone!;
    mapping['image'] = image;
    return mapping;
  }
}
