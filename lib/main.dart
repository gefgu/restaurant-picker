import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'restaurant_form.dart';
import 'restaurant_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFE0433C),
        accentColor: Color(0xFFE0433C),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/form_restaurant': (context) => RestaurantForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Restaurant Picker"),
      ),
      body: StreamBuilder(
        stream: databaseReference.collection('restaurants').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        },
      ),
      backgroundColor: Color(0xFFF8F6EC),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/form_restaurant'),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    snapshot.sort((a, b) => a.data['name'].compareTo(b.data['name']));
    return ListView(
      padding: EdgeInsets.only(top: 16.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final restaurant = Restaurant.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: new BoxDecoration(
          color: Color(0xFF14394E),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF83B2C6).withOpacity(0.4),
                offset: Offset(5.0, 5.0))
          ],
        ),
        child: ListTile(
          title: Text(restaurant.name),
          trailing: Text(restaurant.votes.toString()),
          onTap: () => restaurant.reference
              .updateData({'votes': FieldValue.increment(1)}),
          onLongPress: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title:
                      Text('What you want to do with "${restaurant.name}" ?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text("Update"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/form_restaurant',
                            arguments: restaurant);
                      },
                    ),
                    FlatButton(
                      child: Text("Delete"),
                      onPressed: () {
                        restaurant.reference.delete();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
