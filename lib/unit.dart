import 'package:meta/meta.dart';

class Unit{
  final String name;
  final double conversion;

  //A Unit stores its name and conversion factor

  const Unit({
    @required this.name,
    @required this.conversion,
})  : assert(name != null),
      assert(conversion != null);

  //Create a Unit from JSON Object
  Unit.fromJson(Map jsonMap)
    : assert(jsonMap['name'] != null),
      assert(jsonMap['conversion'] != null),
        name = jsonMap['name'],
        conversion = jsonMap['conversion'].toDouble();

}