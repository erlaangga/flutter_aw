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
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Contact> contactList = List<Contact>();

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

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    updateListView();
    return ListView.builder(
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
    );
  }

  //delete contact
  void deleteContact(Contact object) async {
    object.unlink();
    updateListView();
  }
  //update contact
  void updateListView() {
      Future<List> contactListFuture = Contact().search([]);
      contactListFuture.then((contactList) {
        for (var contactMap in contactList){
          this.contactList.add(Contact.fromMap(contactMap));
        }
        setState(() {
          this.count = contactList.length;
        });
      });
  }

}