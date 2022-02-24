import 'package:flutter/material.dart';
import '../data/sp_helper.dart';
import '../data/session.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final SPHelper spHelper = SPHelper();
  List<Session> sessions = [];

  @override
  void initState() {
    spHelper.init().then((value) => updateScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your training sessions'),
      ),
      body: ListView(
        children: getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showSessionsDialog(context);
        },
      ),
    );
  }

  Future<dynamic> showSessionsDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Insert training"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtDescription,
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                  TextField(
                    controller: txtDuration,
                    decoration: InputDecoration(hintText: 'Duration'),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    txtDescription.text = '';
                    txtDuration.text = '';
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    saveSession();
                  },
                  child: Text('Save'))
            ],
          );
        });
  }

  Future saveSession() async {
    DateTime now = DateTime.now();
    String today = '${now.year}-${now.month}-${now.day}';
    spHelper.getAndSetCounter().then((id) {
      spHelper
          .writeSession(Session(id, today, txtDescription.text,
              int.tryParse(txtDuration.text) ?? 0))
          .then((value) => updateScreen());
      txtDescription.text = '';
      txtDuration.text = '';
      Navigator.pop(context);
    });
  }

  List<Widget> getContent() {
    List<Widget> tiles = [];

    sessions.forEach((session) {
      tiles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          spHelper.delete(session).then((value) => updateScreen());
        },
        child: ListTile(
          title: Text(session.description),
          subtitle: Text('${session.date}-duration: ${session.duration} min'),
        ),
      ));
    });

    return tiles;
  }

  void updateScreen() {
    sessions = spHelper.getSessions();
    setState(() {});
  }
}
