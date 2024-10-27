import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String Input = '';
  String output = '';
  final List btn = [
    'sin',
    'cos',
    'tan',
    'AC',
    'log',
    'ln',
    'exp',
    'DEL',
    '(',
    ')',
    'π',
    '√',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '+',
    '=',
  ];
  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        Input = '';
        output = '0';
      } else if (buttonText == 'DEL') {
        Input = Input.isNotEmpty ? Input.substring(0, Input.length - 1) : '';
      } else if (buttonText == '=') {
        evaluateExpression();
      } else {
        Input += buttonText;
      }
    });
  }

  void evaluateExpression() {
    try {
      Parser parser = Parser();
      Expression exp = parser
          .parse(Input.replaceAll('π', '3.14159').replaceAll('√', 'sqrt'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      output = eval.toString();
    } catch (e) {
      output = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 800,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Input,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    Text(
                      output,
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Buttons
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: btn.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return CalculatorButton(
                    buttonText: btn[index],
                    onTap: () => onButtonPressed(btn[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  CalculatorButton({required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey[850]!;
    Color textColor = Colors.white;

    if (buttonText == 'DEL' || buttonText == 'AC') {
      bgColor = Colors.redAccent;
      textColor = Colors.white;
    } else if (buttonText == '=') {
      bgColor = Colors.greenAccent;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
