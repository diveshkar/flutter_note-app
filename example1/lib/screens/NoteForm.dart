import 'package:notebook/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteForm extends StatefulWidget {
  final Map<String, dynamic>? note;

  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _updatedTime = '';

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _descriptionController.text = widget.note!['description'];
      _updatedTime = widget.note!['updated_time'];
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      if (widget.note == null) {
        // Create a new note
        await DatabaseHelper.instance.insert({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'updated_time': now,
        });
      } else {
        // Update an existing note
        await DatabaseHelper.instance.update({
          '_id': widget.note!['_id'],
          'title': _titleController.text,
          'description': _descriptionController.text,
          'updated_time': now,
        });
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        backgroundColor: Colors.orangeAccent, // AppBar color
      ),
      backgroundColor: Color(0xFFFFF8E1), // Set full background color here
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Allow scrolling if content overflows
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.brown[600]),
                    prefixIcon: Icon(Icons.title, color: Colors.brown[600]), // Icon added
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Background color of the input
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Space between fields
                
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5, // Allow multiple lines
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.brown[600]),
                    prefixIcon: Icon(Icons.description, color: Colors.brown[600]), // Icon added
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Background color of the input
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Space before buttons

                // Row for Save and Cancel Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons in the row
                  children: [
                    // Save Button
                    ElevatedButton(
                      onPressed: _saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, // Button color
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 20), // Space between buttons
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400], // Cancel button color
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
