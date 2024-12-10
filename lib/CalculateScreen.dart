import 'package:flutter/material.dart';

class CalculateScreen extends StatefulWidget {
  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  String _output = "0";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // Scroll to bottom after the frame is built
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget buildButton(String buttonText) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (buttonText == "C") {
              _output = "0";
            } else if (buttonText == "DEL") {
              if (_output.isNotEmpty && _output != "0") {
                _output = _output.substring(0, _output.length - 1);
              }
              if (_output.isEmpty) {
                _output = "0";
              }
            } else {
              if (_output == "0") {
                _output = buttonText;
              } else {
                _output += buttonText;
              }
            }
          });
          _scrollToBottom(); // Ensure scroll to bottom when button is pressed
        },
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: buttonText=="DEL"?10:16.0,
            color: buttonText == "DEL" ? Colors.red : Colors.black, // Change font color for "DEL"
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          height: 400, // Specify the height of the grid
          child: GridView.count(
            crossAxisCount: 5, // Number of columns
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("DEL"),
              buildButton("C"),
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("*"),
              buildButton("/"),
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("+"),
              buildButton("-"),
              buildButton("."),
              buildButton("0"),
              buildButton("00"),
              buildButton("="),
            ],
          ),
        ),
      ],
    );
  }
}
