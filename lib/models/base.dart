import 'package:flutter_aw/helpers/dbhelper.dart';

abstract class BaseModel {
  static DbHelper _dbHelper = DbHelper();

  get dbHelper => _dbHelper;

  int _id = 0;
  bool _new = true;
  String get table;
  List _changedField = List<String>();
  Map<String, dynamic> fields = new Map();

  // konstruktor versi 1
  BaseModel();

  // konstruktor versi 2: konversi dari Map ke BaseModel
  BaseModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
  }

  void assignValue(String key, dynamic value){
    if (value != fields[key]) {
      fields[key] = value;
      _changedField.add(key);
    }
  }

  int get id => _id;

  set id(int value) {

  }

  Future<BaseModel> create() async{
    if (this.id != 0){
      return this;
    }
    int result = await dbHelper.insert(this.table, this.toMap());
    this._id = result;
    this._new = false;
    return this;
  }

  Future<List<Map<String, dynamic>>> search(List domain, {String orderBy, int limit, int offset}) async {
    var mapList = await dbHelper.select('contact', orderBy: 'name');
    return mapList;
  }

  void write() async {
    int result = await dbHelper.update(this.table, this.toMap(fieldState: 'changed'));
  }

  void unlink() async {
    await dbHelper.delete(this.id);
    this._id = 0;
  }

  // konversi dari BaseModel ke Map
  Map<String, dynamic> toMap({String fieldState: 'all'}) {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (id != 0){
      map['id'] = id;
    }
    return map;
  }



}