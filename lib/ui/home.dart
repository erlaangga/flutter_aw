import 'package:flutter/material.dart';
//letak package folder flutter
import 'package:flutter_aw/ui/entryform.dart';
import 'package:flutter_aw/models/contact.dart';
import 'package:flutter_aw/helpers/dbhelper.dart';
//untuk memanggil fungsi yg terdapat di daftar pustaka sqflite
import 'dart:async';
//pendukung program asinkron

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _HomeState(){
    updateListView();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Contact> contactList = List<Contact>();

  var contactHelper = Contact();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Data-Data'),
      ),
      body: createListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          await navigateToEntryForm(context, null);
          updateListView();
        },
      ),
    );
  }

  Future<Contact> navigateToEntryForm(BuildContext context, Contact contact) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return EntryForm(contact);
            }
        )
    );

    return result;
  }

  RefreshIndicator createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: updateListView,
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.people),
              ),
              title: Text(this.contactList[index].name, style: textStyle,),
              subtitle: Text(this.contactList[index].phone),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  deleteContact(contactList[index]);
                },
              ),
              onTap: () async {
                await navigateToEntryForm(context, this.contactList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  //delete contact
  void deleteContact(Contact object) async {
    object.unlink();
    this.contactList.removeWhere((cont)=>cont.id == object.id);
    updateListView();
  }

  //update contact
  Future<Null> updateListView() {
      Future<List> contactListFuture = contactHelper.search([]);
      return contactListFuture.then((contactList) {
        setState(() {
          for (var contactMap in contactList){
            this.contactList.add(Contact.fromMap(contactMap));
          }
          this.count = contactList.length;
        });
      });
  }

}