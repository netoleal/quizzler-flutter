import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quiz_brain.dart';

void main() => runApp(Quizzler());

QuizBrain quizBrain = QuizBrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  bool checkAnswer({
    bool answer,
  }) {
    bool questionAnswer = quizBrain.getQuestionAnswer();
    return questionAnswer == answer;
  }

  void pushAnswer({bool isCorrect}) {
    Icon icon = Icon(
      isCorrect ? Icons.check : Icons.close,
      color: isCorrect ? Colors.green : Colors.red,
    );
    setState(() {
      scoreKeeper.add(icon);
    });
  }

  void pressHandler(answer, BuildContext context) {
    if (!quizBrain.hasNextQuestion()) {
      Alert alert = Alert(
        context: context,
        title: 'jogo acabou!',
        desc: 'voltando ao inicio',
        type: AlertType.info,
        buttons: [
          DialogButton(
            child: Text('Ok!'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
      alert.show();
      setState(() {
        quizBrain.reset();
        scoreKeeper.removeRange(0, scoreKeeper.length);
      });
      return;
    }

    pushAnswer(
      isCorrect: checkAnswer(
        answer: answer,
      ),
    );
    setState(() {
      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                pressHandler(true, context);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                pressHandler(false, context);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
