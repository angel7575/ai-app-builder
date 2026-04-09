import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  List<String> messages = [];

  Future<String> preguntarIA(String prompt) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer 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",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "gpt-4.1-mini",
        "messages": [
          {"role": "user", "content": prompt}
        ]
      }),
    );

    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  }

  void enviar() async {
    String texto = controller.text;

    setState(() {
      messages.add("Tú: $texto");
    });

    controller.clear();

    String respuesta = await preguntarIA(texto);

    setState(() {
      messages.add("IA: $respuesta");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IA 🔥")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: messages.map((m) => Text(m)).toList(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: controller),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: enviar,
              )
            ],
          )
        ],
      ),
    );
  }
}
