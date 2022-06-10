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
int itemCountL = 0;

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
        stream: db.collection('todos').orderBy("nroboleto").snapshots(),
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
                title: Text(
                    'Boleto Nro ' + documentSnapshot['nroboleto'].toString()),
                subtitle: Text('Cliente: ' + documentSnapshot['cliente']),
                onTap: () {
                  // Here We Will Add The Update Feature and passed the value 'true' to the is update
                  // feature.
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      itemCountL = snapshot.data?.docs.length + 1;
                      print(itemCountL);
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
              labelText: 'Fecha',
              hintText: 'Ingrese la fecha DD-MM-YYYY',
            ),
            onChanged: (String _val) {
              // Storing the value of the text entered in the variable value.
              fecha = _val;
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // Used a ternary operator to check if isUpdate is true then display
              // Update Todo.
              labelText: 'Origen',
              hintText: 'Ingrese el lugar de origen',
            ),
            onChanged: (String _val) {
              // Storing the value of the text entered in the variable value.
              origen = _val;
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // Used a ternary operator to check if isUpdate is true then display
              // Update Todo.
              labelText: 'Destino',
              hintText: 'Ingrese el lugar de destino',
            ),
            onChanged: (String _val) {
              // Storing the value of the text entered in the variable value.
              destino = _val;
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // Used a ternary operator to check if isUpdate is true then display
              // Update Todo.
              labelText: 'Precio',
              hintText: 'Ingrese el precio',
            ),
            onChanged: (String _val) {
              // Storing the value of the text entered in the variable value.
              precio = _val;
            },
          ),
        ),
        TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.lightBlueAccent),
            ),
            onPressed: () {
              db.collection('todos').add({
                'nroboleto': itemCountL,
                'cliente': 'Jose',
                'fecha': fecha,
                'origen': origen,
                'destino': destino,
                'precio': int.parse(precio!)
              });
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

showBottomSheetInfo(
    BuildContext context, bool isUpdate, DocumentSnapshot? documentSnapshot) {
  // Added the isUpdate argument to check if our item has been updated
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: FutureBuilder<DocumentSnapshot>(
      builder: ((context, snapshot) {
        print(documentSnapshot!['nroboleto']);
        return Center(
          child: Card(
            child: Column(
              children: <Widget>[
                // ignore: unnecessary_new
                new Text(
                  "Nro Boleto: " + documentSnapshot['nroboleto'].toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                ),
                const Divider(),
                // ignore: unnecessary_new
                new Text(
                  "Cliente: " + documentSnapshot['cliente'].toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                ),
                const Divider(),
                // ignore: unnecessary_new
                new Text(
                  "Fecha: " + documentSnapshot['fecha'].toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                // ignore: unnecessary_new
                new Text(
                  "Precio: " + documentSnapshot['precio'].toString() + " Bs",
                  style: const TextStyle(fontSize: 18.0),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                // ignore: unnecessary_new
                new Text(
                  "Origen: " + documentSnapshot['origen'].toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                ),
                const Divider(),
                // ignore: unnecessary_new
                new Text(
                  "Destino: " + documentSnapshot['destino'].toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const Divider(),
                Container(
                  width: 300.0,
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}
