import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/winds.dart'; // Replace with the correct path to your Song widget
import 'package:gemini_app/services/firebaseService.dart'; // Import your FirebaseService
import 'package:gemini_app/services/geminiService.dart'; // Import your GeminiService

class Generate extends StatefulWidget {
  final String title;
  Generate({super.key, required this.title});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  final FirebaseService _firebaseService =
      FirebaseService(); // Initialize FirebaseService
  final GeminiService _geminiService =
      GeminiService(); // Initialize GeminiService

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await _firebaseService.initializeFirebase();
  }

  Future<void> _fetchContents() async {
    String generatedContent;
    try {
      setState(() {
        loading = true;
      });

      // Use GeminiService to generate content
      generatedContent =
          await _geminiService.generate(widget.title, controller.text);

      // Store the generated content in Firestore using FirebaseService
      await _firebaseService.addDocument('generatedContents', {
        'title': widget.title,
        'description': controller.text,
        'content': generatedContent,
        'email': _firebaseService.getCurrentUser()?.email,
        'timestamp':
            FieldValue.serverTimestamp(), // Add a timestamp for sorting
      });

      setState(() {
        loading = false;
      });

      // Navigate to the Song screen with the generated content
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Song(title: controller.text, ans: generatedContent)),
      );
    } catch (e) {
      print('Error obtaining Gemini instance or fetching content: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              controller: controller,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText:
                    'What should the ${widget.title.toLowerCase()} be about?',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                contentPadding: const EdgeInsets.all(20),
                border: InputBorder.none,
                prefixIcon: Icon(
                  widget.title == 'Song'
                      ? Icons.music_note
                      : widget.title == 'Story'
                          ? Icons.book
                          : Icons.text_fields,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          loading
              ? const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'AI is thinking...',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _fetchContents,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Generate Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(CupertinoIcons.sparkles,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
