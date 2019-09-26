import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

int userId;
Map finalSchoolData;
bool schoolStatus;

class SearchMe extends StatefulWidget {
  SearchMe({this.callme});
  final ValueChanged callme;
  @override
  _SearchMeState createState() => _SearchMeState();
}

class _SearchMeState extends State<SearchMe> {
  final TextEditingController _filter = TextEditingController();
  final dio = Dio();
  String school;
  String _searchText = "";
  List names = List();
  List filteredNames = List();
  Widget _appBarTitle = Text('Search your school');

  _SearchMeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    schoolStatus = false;
    this._appBarTitle = TextField(
      controller: _filter,
      decoration: InputDecoration(
          prefixIcon: Hero(tag: "searchList", child: Icon(Icons.search)),
          hintText: 'Find your school'),
    );
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(height: 50, child: _appBarTitle),
        Container(height: 70, child: _buildList()),
      ],
    );
    // Scaffold(
    //   appBar: _buildBar(context),
    //   body: Container(
    //     child: _buildList(),
    //   ),
    //   resizeToAvoidBottomPadding: false,
    // );
  }

  Widget _buildList() {
    if (!(_searchText.length == 0)) {
      List tempList = List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['school']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: Image.network(
              filteredNames[index]["logo"],
              height: 30,
              width: 30,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(filteredNames[index]["school"]),
              ],
            ),
            onTap: () {
              finalSchoolData = {
                "name": filteredNames[index]["school"],
                "logo": filteredNames[index]["logo"]
              };
              widget.callme(finalSchoolData);
              print(filteredNames[index]["school"]);
            });
      },
    );
  }

  //Schools are generated here
  void _getNames() async {
    Map sdata;
    List tempList = List();
    var data = await Firestore.instance.collection("schools").getDocuments();
    data.documents.forEach((f) => {
          sdata = {
            "school": f.documentID,
            "address": f.data["address"],
            "logo": f.data["logo"]
          },
          tempList.add(sdata)
        });
    if (mounted)
      setState(() {
        names = tempList;
        names.shuffle();
        filteredNames = names;
      });
  }
}
