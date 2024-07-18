import 'package:latlong2/latlong.dart';

class MapBox{
  static String urlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static String sharedUrl = 'https://api.mapbox.com/styles/v1/cocytus159/clyrdqb90008e01ph8r09dsnm/wmts?access_token=pk.eyJ1IjoiY29jeXR1czE1OSIsImEiOiJjbHlyY2Q2YWowMzE4MmlvcGN2YTllOTY3In0.O5jiO9BuE2kC19GdYbEM2w';
  static const myLocation = LatLng(30, 100);
}