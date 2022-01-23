import 'package:flutter/material.dart';
import 'package:face_net_authentication/sqlite/sql_helper.dart';
import 'package:face_net_authentication/sqlite/excel.dart';

class MyShow extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyShow> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(22, 21, 31, 1.0),
          title: const Text('Data Save'),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0), child: Createxcel()),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Color.fromRGBO(22, 21, 31, 1.0),
                child: ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.grey[200],
                    margin: const EdgeInsets.all(15),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text("Nama"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(_journals[index]['name']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text("Jam Masuk"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(_journals[index]['jammasuk']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text("Tanggal"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(_journals[index]['date']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              onPressed: () =>
                                  _deleteItem(_journals[index]['id']),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
