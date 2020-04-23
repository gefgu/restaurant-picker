import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'restaurant_model.dart';

class RestaurantForm extends StatefulWidget {
  RestaurantForm({Key key}) : super(key: key);

  @override
  RestaurantFormState createState() => RestaurantFormState();
}

class RestaurantFormState extends State<RestaurantForm> {
  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context).settings.arguments;

    TextEditingController textController = TextEditingController();

    String appBarTitle = "Add Restaurant";

    var functionToCall;

    if (argument != null) {
      appBarTitle = "Edit Restaurant";
      Restaurant restaurant = argument;
      textController.text = restaurant.name;
      functionToCall =
          (String name) => restaurant.reference.updateData({"name": name});
    } else {
      functionToCall = (String name) => Firestore.instance
          .collection('restaurants')
          .add({'name': name, 'votes': 0});
    }
    return Scaffold(
      appBar: new AppBar(
        title: Text(appBarTitle),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
          onSubmitted: (submit) {
            functionToCall(submit);
            Navigator.pop(context);
          },
          autofocus: true,
          decoration: InputDecoration(
              hintText: "Enter the restaurant name here...",
              labelText: "Restaurant Name",
              fillColor: Colors.black),
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Color(0xFFF8F6EC),
    );
  }
}
