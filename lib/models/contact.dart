import 'package:flutter_aw/models/base.dart';

class Contact extends BaseModel {
  String get table => 'contact';

  Map<String, dynamic> _newFields = {'name': null, 'phone': null};

  // konstruktor versi 1
  Contact(): super(){
    fields.addAll(_newFields);
  }

  // konstruktor versi 2: konversi dari Map ke Contact

  Contact.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    this.name = map['name'];
    this.phone = map['phone'];
  }

  // setter harus lebih dari satu statement
  String get name => fields['name'];
  String get phone => fields['phone'];

  // setter
  set name(String value) {
    String key = 'name';
    assignValue(key, value);
  }

  set phone(String value) {
    String key = 'phone';
    assignValue(key, value);
  }

  @override
  // TODO: implement apiDeleteLink
  String get apiDeleteLink => '${BaseModel.baseUrl}/api/contacts/$id';

  @override
  // TODO: implement apiGetLink
  String get apiGetLink {
    if (odooId == 0) {
      return '${BaseModel.baseUrl}/api/contacts';
    }
    else {
      return '${BaseModel.baseUrl}/api/contact/$odooId';
    }
  }

  @override
  // TODO: implement apiPostLink
  String get apiPostLink => null;

  @override
  // TODO: implement apiPutLink
  String get apiPutLink => null;

}
