import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/screens/cars/car_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheSearch extends SearchDelegate<String> {
  TheSearch({ this.contextPage});

  BuildContext? contextPage;
  final suggestions1 = ["لا توجد نتائج"];

  @override
  String get searchFieldLabel => "ابحث عن مركبة";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions =
        Provider.of<Cars>(context, listen: false).searchResult(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CarReviewScreen.routeName,
              arguments: suggestions[index].id);
        },
        child: ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text(suggestions[index].title??"")),
      ),
    );
    //return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //final suggestions = query.isEmpty ? suggestions1 : [];
    final suggestions =
        Provider.of<Cars>(context, listen: false).searchResult(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CarReviewScreen.routeName,
              arguments: suggestions[index]);
        },
        child: ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text(suggestions[index].title??"")),
      ),
    );
  }
}
