import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unitconverter_app/api.dart';
import 'package:unitconverter_app/category.dart';
import 'package:unitconverter_app/unit.dart';
import 'package:unitconverter_app/category_tile.dart';
import 'package:unitconverter_app/unit_converter.dart';
import 'package:unitconverter_app/backdrop.dart';

final _backgroundColor = Colors.green[99];

// Stateless widget
/*
* class CategoryRoute extends StatelessWidget{}
* */
// Stateful widget

class CategoryRoute extends StatefulWidget {
  CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  final _categories = <Category>[];
  Category _defaultCategory;
  Category _currentCategory;

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  static const _icons = <String>[
    'assests/icons/length.png',
    'assests/icons/area.png',
    'assests/icons/volume.png',
    'assests/icons/mass.png',
    'assests/icons/time.png',
    'assests/icons/digital_storage.png',
    'assests/icons/power.png',
    'assests/icons/currency.png',
  ];

  @override
  Future<void> didChangedDependencies() async {
    super.didChangeDependencies();
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Failed to Map and retrieved data from API');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        iconLocation: _icons[categoryIndex],
      );

      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  Future<void> _retrieveApiCategory() async {
    setState(() {
      _categories.add(Category(
        name: apiCategory['name'],
        units: [],
        color: _baseColors.last,
        iconLocation: _icons.last,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Category(
            name: apiCategory['name'],
            color: _baseColors.last,
            iconLocation: _icons.last,
            units: []));
      });
    }
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

/*
List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 7.5),
      child: _buildCategoryWidgets(),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unit Converter',
        style: TextStyle(color: Colors.black, fontSize: 29.5),
      ),
      centerTitle: true,
      backgroundColor: _backgroundColor,
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }


 */
  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 170.0,
          width: 170.0,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      assert(debugCheckHasMediaQuery(context));
      final listView = Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0,
        ),
        child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
      );
      return Backdrop(
        currentCategory:
            _currentCategory == null ? _defaultCategory : _currentCategory,
        frontPanel: _currentCategory == null
            ? UnitConverter(
                category: _defaultCategory,
              )
            : UnitConverter(
                category: _currentCategory,
              ),
        backPanel: listView,
        frontTitle: Text('Integrated Converter'),
        backTitle: Text('Select a Category'),
      );
    }
  }
}
