import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_test/db/my_photo.dart';

class MyDatabase {
  static final String _rootSite = 'http://jsonplaceholder.typicode.com';
  static final String _usersLink = '$_rootSite/users/';
  static final String _photosLink = '$_rootSite/photos/';

  static Future<List<Map<String, dynamic>>> getListOfUsers() async {
    http.Response response = await http.get(
      Uri.encodeFull(_usersLink),
      headers: {'Accept': 'Application/json'},
    );
    // This is a comment!
    List<Map<String, dynamic>> list = [];
    List data = json.decode(response.body);

    data.forEach((user) {
      list.add({
        'name': user['name'],
        'email': user['email'],
        'id': user['id'],
      });
    });

    return list;
  }

  static Future<Map<String, dynamic>> getUserById(int id) async {
    http.Response response = await http.get(
      Uri.encodeFull('$_usersLink?id=$id'),
      headers: {'Accept': 'Application/json'},
    );
    var data = json.decode(response.body)[0];
    return {
      'username': data['username'],
      'address-street': data['address']['street'],
      'address-suite': data['address']['suite'],
      'address-city': data['address']['city'],
      'address-zipcode': data['address']['zipcode'],
      'address-geo-lat': data['address']['geo']['lat'],
      'address-geo-lng': data['address']['geo']['lng'],
      'phone': data['phone'],
      'website': data['website'],
      'company-name': data['company']['name'],
      'company-catchPhrase': data['company']['catchPhrase'],
      'company-bs': data['company']['bs'],
    };
  }

  static Future<List<MyPhoto>> getPhotos() async {
    http.Response response = await http.get(
      Uri.encodeFull(_photosLink),
      headers: {'Accept': 'Application/json'},
    );
    List<MyPhoto> result = [];
    List data = json.decode(response.body);
    
    data.forEach((photo) {
      result.add(MyPhoto(
        albumId: photo['albumId'],
        id: photo['id'],
        title: photo['title'],
        url: photo['url'],
        thumbnail: photo['thumbnailUrl'],
      ));
    },);

    return result;
  }
}
