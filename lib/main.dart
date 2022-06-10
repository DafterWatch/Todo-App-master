import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCZMIHaiOzXKkIWCDbAIy-8Mfo6ijL6bXg",
      appId: "1:148990294793:android:3fe186ff7e9245c98031d8",
      messagingSenderId:
          "148990294793-rs0ccj0c83i9916iv4agrtpddmdttjit.apps.googleusercontent.com",
      projectId: "crud-prueba1",
    ),
  );
  runApp(const MyApp());
}

final db = FirebaseFirestore.instance;
String? cliente;
String? destino;
String? fecha;
String? nroboleto;
String? origen;
String? precio;
String? idTicket;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FloatingActionButton(
        onPressed: () {
          // When the User clicks on the button, display a BottomSheet
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return showBottomSheet(context, false, null);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Venta Tickets'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        // Reading Items form our Database Using the  Builder widget
        stream: db.collection('todos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, int index) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
              idTicket = documentSnapshot.id;
              return ListTile(
                title: Text(documentSnapshot.id +
                    ' ' +
                    documentSnapshot['nroboleto'].toString() +
                    ' / ' +
                    documentSnapshot['cliente'] +
                    ' / ' +
                    documentSnapshot['fecha']),
                subtitle: Text(documentSnapshot['origen'] +
                    ' / ' +
                    documentSnapshot['destino'] +
                    ' / ' +
                    documentSnapshot['precio'].toString() +
                    ' Bs'),
                onTap: () {
                  // Here We Will Add The Update Feature and passed the value 'true' to the is update
                  // feature.
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return showBottomSheetInfo(
                          context, true, documentSnapshot);
                    },
                  );
                },
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  onPressed: () {
                    // Here We Will Add The Delete Feature
                    db.collection('todos').doc(documentSnapshot.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

showBottomSheet(
    BuildContext context, bool isUpdate, DocumentSnapshot? documentSnapshot) {
  // Added the isUpdate argument to check if our item has been updated
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // Used a ternary operator to check if isUpdate is true then display
              // Update Todo.
              labelText: isUpdate ? 'Update Todo' : 'Add Todo',
              hintText: 'Enter An Item',
            ),
            onChanged: (String _val) {
              // Storing the value of the text entered in the variable value.
              //value = _val;
            },
          ),
        ),
        TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.lightBlueAccent),
            ),
            onPressed: () {
              // Check to see if isUpdate is true then update the value else add the value
              if (isUpdate) {
                db.collection('todos').doc(documentSnapshot?.id).update({
                  //'todo': value,
                });
              } else {
                //db.collection('todos').add({'todo': value});
              }
              Navigator.pop(context);
            },
            child: isUpdate
                ? const Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text('ADD', style: TextStyle(color: Colors.white))),
      ],
    ),
  );
}

showBottomSheetInfo2(
    BuildContext context, bool isUpdate, DocumentSnapshot? documentSnapshot) {
  // Added the isUpdate argument to check if our item has been updated
  return Padding(
    padding: const EdgeInsets.all(20.0),
    /*child: Center(
      child: Card(
        child: Column(
          children: <Widget>[
            new Text(
              "Name :",
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Divider(),
            new Text(
              "Codebar : ",
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Divider(),
            new Text(
              "Description : ",
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Divider(),
            new Text(
              "Price : ",
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Divider(),
            new Text(
              "Stock : ",
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Divider(),
            Container(
              width: 300.0,
            ),
          ],
        ),
      ),
    ),*/
  );
}

showBottomSheetInfo(
    BuildContext context, bool isUpdate, DocumentSnapshot? documentSnapshot) {
  // Added the isUpdate argument to check if our item has been updated
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: FutureBuilder<DocumentSnapshot>(
      future: db.doc('e4EMEoUAQeDVpy12x6bM').get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data.toString()}');
        }
        return Text('Loading');
      }),
      /*builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (
            context,
            int index,
          ) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
            idTicket = documentSnapshot.id;
            final docRef = db.collection("todos").doc("e4EMEoUAQeDVpy12x6bM");
            docRef.get().then(
                  (res) => {
                    res.data()?.forEach((key, value) {
                      switch (key.toString()) {
                        case "fecha":
                          fecha = value.toString();
                          print(fecha.toString());
                          break;
                        case "origen":
                          origen = value.toString();
                          print(origen.toString());
                          break;
                        case "cliente":
                          cliente = value.toString();
                          print(cliente.toString());
                          break;
                        case "precio":
                          precio = value.toString();
                          print(precio.toString());
                          break;
                        case "destino":
                          destino = value.toString();
                          print(destino.toString());
                          break;
                        case "nroboleto":
                          nroboleto = value.toString();
                          print(nroboleto.toString());
                          break;
                      }
                    })
                  },
                  onError: (e) => print("Error completing: $e"),
                );
            return ListTile(
              title: Text(nroboleto.toString() +
                  ' / ' +
                  cliente.toString() +
                  ' / ' +
                  fecha.toString()),
              subtitle: Text(origen.toString() +
                  ' / ' +
                  destino.toString() +
                  ' / ' +
                  precio.toString() +
                  ' Bs'),
            );
          },
        );
      },*/
    ),
  );
}
