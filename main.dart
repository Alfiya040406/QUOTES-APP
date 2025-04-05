import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(QuotesApp());
}

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuotesScreen(),
    );
  }
}

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  String currentQuote = "Tap the button to get inspired!";
  String author = "";
  bool isLoading = false;
  double opacity = 0.0;

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
      opacity = 0.0;
    });

    try {
      final response =
          await http.get(Uri.parse("https://qapi.vercel.app/api/random"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await Future.delayed(Duration(milliseconds: 300));
        setState(() {
          currentQuote = data['quote'] ?? "No quote found.";
          author = data['author'] ?? "";
          opacity = 1.0;
        });
      } else {
        setState(() {
          currentQuote = "Failed to fetch quote.";
          author = "";
          opacity = 1.0;
        });
      }
    } catch (e) {
      setState(() {
        currentQuote = "Error: $e";
        author = "";
        opacity = 1.0;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: opacity,
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              '"$currentQuote"',
                              style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            if (author.isNotEmpty)
                              Text(
                                "- $author",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.right,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton.icon(
                          onPressed: fetchQuote,
                          icon: Icon(Icons.format_quote),
                          label: Text("New Quote"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
