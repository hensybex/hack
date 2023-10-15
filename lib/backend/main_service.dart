import 'dart:convert';
import 'package:hack/models/partner.dart';
import 'package:hack/screens/office_screen.dart';
import 'package:http/http.dart' as http;
import 'package:hack/models/atm.dart';
import 'package:hack/models/office.dart';

class BackendService {
  Future<List<Atm>> fetchAtms(
      {double? userLat, double? userLng, double? radius}) async {
    const String baseUrl = 'http://194.87.252.63:3000';
    final response = await http.get(Uri.parse(
        '$baseUrl/atms?userLat=$userLat&userLng=$userLng&radius=$radius'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data.length);
      return data.map((atm) => Atm.fromJson(atm)).toList();
    } else {
      throw Exception('Failed to load Atms');
    }
  }

  Future<List<Office>> fetchOffices(
      {double? userLat, double? userLng, double? radius}) async {
    const String baseUrl = 'http://194.87.252.63:3000';
    print("Sending request");
    final response = await http.get(Uri.parse(
        '$baseUrl/offices?userLat=$userLat&userLng=$userLng&radius=$radius'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((office) => Office.fromJson(office)).toList();
    } else {
      throw Exception('Failed to load Offices');
    }
  }

  Future<RouteResponse> fetchRoute(
      {required String startPositions,
      required String finishPositions,
      required String type}) async {
    const String baseUrl = 'http://194.87.252.63:8086';
    final response = await http.get(Uri.parse(
        '$baseUrl/api/route/?start=$startPositions&finish=$finishPositions&type=$type'));
    print(
        '$baseUrl/api/route/?start=$startPositions&finish=$finishPositions&type=$type');
    print("Printing body");
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return RouteResponse.fromJson(data);
    } else {
      throw Exception('Failed to load Route data');
    }
  }

  Future<List<Partner>> fetchPartners() async {
    const String baseUrl = 'http://194.87.252.63:8086';
    final response = await http.get(Uri.parse('$baseUrl/api/partners'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((partner) => Partner.fromJson(partner)).toList();
    } else {
      throw Exception('Failed to load Partners');
    }
  }
}
