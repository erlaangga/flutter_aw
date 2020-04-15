import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_aw/helpers/dbhelper.dart';

abstract class BaseModel {
  static DbHelper _dbHelper = DbHelper();

  static final String baseUrl = 'http://192.168.122.1:8069';
  String get apiGetLink;
  String get apiPostLink;
  String get apiPutLink;
  String get apiDeleteLink;

  get dbHelper => _dbHelper;

  int _id = 0;
  bool _new = true;
  String get table;
  List _changedField = List<String>();
  Map<String, dynamic> fields = new Map();
  int _odooId = 0;

  // konstruktor versi 1
  BaseModel();

  // konstruktor versi 2: konversi dari Map ke BaseModel
  BaseModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
  }

//  factory BaseModel.search(List domain, {String orderBy, int limit, int offset}) {
//    var mapList = _dbHelper.select(this._table, orderBy: 'name');
//    return mapList;
//  }

  void assignValue(String key, dynamic value){
    if (value != fields[key]) {
      fields[key] = value;
      _changedField.add(key);
    }
  }

  int get id => _id;

  set id(int value) {

  }

  int get odooId => _odooId;

  Future<BaseModel> create() async{
    if (this.id != 0){
      return this;
    }
    int result = await dbHelper.insert(this.table, this.toMap());
    this._id = result;
    this._new = false;
    return this;
  }

  Future<List<Map<String, dynamic>>> search(List domain, {String orderBy: 'id', int limit, int offset}) async {
    var mapList = await dbHelper.select(this.table, orderBy: orderBy);
//    var url = 'http://192.168.43.230:8069/api/contacts';
//    var headers = {'Cookie':'session_id=d172c2fcd4364bca6b76c6c6665ca3337d520a46'};
//    final response = await http.get(url, headers: headers);
//    print('Response status: ${response.statusCode}');
//    var mapList = json.decode(response.body);
    return mapList;
  }

  void write() async {
    await dbHelper.update(this.table, this.toMap(fieldState: 'changed'));
  }

  void unlink() async {
    await dbHelper.delete(this.id);
    this._id = 0;
  }

  // konversi dari BaseModel ke Map
  Map<String, dynamic> toMap({String fieldState: 'all'}) {
    Map<String, dynamic> map = fields;
    if (id != 0){
      map['id'] = id;
    }

    switch (fieldState){
      case 'all': {fields.forEach((k, v) => map[k] = v);}
        break;
      case 'changed': {_changedField.forEach((k) => map[k] = fields[k]);}
        break;
    }
    return map;
  }

}