// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotes',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('QUOTES',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 10.0)),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: QuoteListView(),
        ),
      )
    );
  }
}
class QuoteListView extends StatefulWidget {
  const QuoteListView({Key? key}) : super(key: key);
  @override
  _QuoteListViewState createState() => _QuoteListViewState();
}
class _QuoteListViewState extends State<QuoteListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>>(
  future: getQuotes('https://type.fit/api/quotes'),
  
  builder: (BuildContext context, AsyncSnapshot<List<Quote>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
        Icon(Icons.error_outline, color: Color.fromARGB(255, 243, 122, 114), size: 200),
        SizedBox(height: 16),
        Text('Oops! Unexpected error has been occoured.', style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),)
        ],
      );
      // return Text('Oops! Unexpected error has been occoured. \n ${snapshot.error}');
    } else if (snapshot.hasData) {
      // Render the list view using snapshot.data as the quotes
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(snapshot.data![index].quote),
            subtitle: Text(snapshot.data![index].author),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: snapshot.data![index].quote));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Quote copied to clipboard'),
                ));
              },
            ),
          );
        },
      );
    } else {
      return const Text('No quotes available');
    }
  });
  }
}
