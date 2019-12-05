/*
*   App developed by: Habibu Abdullahi
*   @2019.11.15
*   With the helped of Udacity MOOC course
* */

import 'package:flutter/material.dart';
import 'package:unitconverter_app/category.dart';
import 'package:unitconverter_app/category_route.dart';

/*
const _biggerFont = TextStyle(fontSize: 20.5);
const _categoryName = 'Cake';
const _categoryColor = Colors.lightGreen;
const _categoryIcon = Icons.cake;
*/

void main() => runApp(UnitConverter());

class UnitConverter extends StatelessWidget {
  // Root Widget of the UnitConverte app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Integrated Converter',
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: CategoryRoute(),
      /*
      *   No more need of Scaffolding()
      *  Center(
          child: cat.Category(
              name: _categoryName,
              color: _categoryColor,
              iconLocation: _categoryIcon
          ),

        ),
      ),
      *
      * */
    );
  }
}
