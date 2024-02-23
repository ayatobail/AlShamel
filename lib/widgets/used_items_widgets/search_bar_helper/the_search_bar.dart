import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItem_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheSearch extends SearchDelegate<String> {
  TheSearch({ this.contextPage});

  BuildContext? contextPage;
  final suggestions1 = ["لا توجد نتائج"];

  @override
  String get searchFieldLabel => "ابحث عن";

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
        Provider.of<UsedItems>(context, listen: false).searchResult(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UsedItemReviewScreen.routeName,
              arguments: suggestions[index].useditemsid);
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
    final suggestions =
        Provider.of<UsedItems>(context, listen: false).searchResult(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UsedItemReviewScreen.routeName,
              arguments: suggestions[index].useditemsid);
        },
        child: ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text(suggestions[index].title??"")),
      ),
    );
  }
}
