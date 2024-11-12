import 'package:flutter/material.dart';
import 'package:notebook/databaseHelper.dart';
import 'package:notebook/screens/NoteForm.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() async {
    final data = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _notes = data;
    });
  }

  void _deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    _refreshNotes();
  }

  void _editNote(Map<String, dynamic> note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteForm(note: note)),
    );
    _refreshNotes();
  }

  void _createNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteForm()),
    );
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NoteBook',
          style: TextStyle(fontFamily: 'Cursive', fontSize: 24), // Cursive style for a notebook feel
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0, // Flat appbar to match the notebook style
      ),
      body: Container(
        color: Color(0xFFFFF8E1), // Light yellow background, like a notebook page
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return Card(
              color: Colors.yellow[100], // Yellowish background for each note
              elevation: 4, // A slight shadow to lift the note card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0), // Add padding inside the note
                title: Text(
                  note['title'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800], // Darker color for text
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8), // Space between title and description
                    Text(
                      note['description'],
                      style: TextStyle(fontSize: 16, color: Colors.brown[600]), // Softer color for description
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Updated: ${note['updated_time']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.brown[600]),
                      onPressed: () => _editNote(note),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400]),
                      onPressed: () => _deleteNote(note['_id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
