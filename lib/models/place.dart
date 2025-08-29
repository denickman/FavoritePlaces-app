import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:favoriteplaces/models/place_location.dart';


const uuid = Uuid();

class Place {

  Place({
    required this.title, 
    required this.image,
    required this.location,
    String? id
    }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}