import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoundedSearchBar extends StatefulWidget {
  @override
  _RoundedSearchBarState createState() => _RoundedSearchBarState();
}

class _RoundedSearchBarState extends State<RoundedSearchBar> {
  String _selectedOption = 'exchange';
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          // Dropdown
          DropdownButton<String>(
            value: _selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue!;
              });
            },
            items: <String>['exchange', 'want', 'user'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Input field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Search button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
              _performSearch();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    String searchText = _searchController.text.toLowerCase();

    if (_selectedOption == 'user') {
      // Search users in the "Users" collection based on fName or lName
      QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore
          .instance
          .collection("Users")
          .where('fName', isGreaterThanOrEqualTo: searchText)
          .where('fName', isLessThan: searchText)
          .get();

      // Display user cards
      List<Widget> userCards =
          users.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> user) {
        return Card(
          child: ListTile(
            title: Text('${user['fName']} ${user['lName']}'),
            subtitle: Text('UID: ${user.id}'),
          ),
        );
      }).toList();

      // Display the search results
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Search Results'),
            content: SingleChildScrollView(
              child: Column(
                children: userCards,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle other search categories ('exchange' and 'want') based on your requirements
    }
  }
}
