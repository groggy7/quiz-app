import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'question_model.dart';
import 'package:flutter/cupertino.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> questionlist = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer?
      selectedanswer; //? mark allows us to leave the variable uninitialized for now
  bool submitButtonVisibility = false;
  void _showAlertDialog(BuildContext context, int index) {
    String warning = '';
    if (index == 0) {
      warning = 'This is first question\nYou cant go back';
    } else if (index == 1) {
      warning = 'This is last question of the quiz';
    }
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: Text(warning),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = WidgetsBinding.instance.window.physicalSize.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff204f7a),
        title: Text(
          //question X --> X.png, images are called by question's index number
          'Question ${currentQuestionIndex + 1}/${questionlist.length.toString()}',
          style: GoogleFonts.lato(),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff2d6296), Color(0xff4ca7e2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            _questionWidget(),
            _questionPhoto(),
            _answerList(),
            if (submitButtonVisibility) _submitButton(true),
          ],
        ),
      ),
      /////////////////////////////////////////////////
      bottomNavigationBar: Container(
        width: double.infinity,
        height: deviceHeight * 1 / 45,
        color: const Color(0xff204f7a),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 30,
              margin: const EdgeInsets.only(left: 5),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (currentQuestionIndex > 0)
                      --currentQuestionIndex;
                    else {
                      _showAlertDialog(context, 0);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  primary: const Color(0xff173d6a),
                  fixedSize: const Size.fromWidth(110),
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                label: const Text("Previous"),
              ),
            ),
            const Spacer(), //in order to share all remaining spaces
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff173d6a),
                  fixedSize: const Size.fromWidth(80),
                ),
                onPressed: () {},
                child: const Text('Explain'),
              ),
            ),
            const Spacer(),
            Container(
              width: 110,
              height: 30,
              margin: const EdgeInsets.only(right: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  primary: const Color(0xff173d6a),
                  fixedSize: const Size.fromWidth(110),
                ),
                onPressed: () {
                  setState(() {
                    if (currentQuestionIndex < questionlist.length - 1)
                      ++currentQuestionIndex;
                    else {
                      _showAlertDialog(context, 1);
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Next'),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _questionWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Text(
            questionlist[currentQuestionIndex].questionText,
            style: GoogleFonts.lato(
                color: Colors.white,
                textStyle: Theme.of(context).textTheme.headline6),
          ),
        ),
      ],
    );
  }

  _questionPhoto() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Image(
        image: AssetImage("assets/${currentQuestionIndex + 1}.png"),
        width: MediaQuery.of(context).size.width * 0.9,
      ),
    );
  }

  _answerList() {
    return Column(
      children: questionlist[currentQuestionIndex]
          .answerList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedanswer;
    return Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: ElevatedButton(
          onPressed: () {
            setState(
              () {
                selectedanswer = answer;
                submitButtonVisibility = true;
                isSelected = false;
              },
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            primary: isSelected ? Colors.orangeAccent : const Color(0xffe8f6fd),
            onPrimary: const Color(0xff40464f),
            textStyle: GoogleFonts.lato(fontSize: 16),
          ),
          child: Text(answer.answerText),
        ));
  }

  Widget _submitButton(bool isAnswerTrue) {
    String buttonText =
        (currentQuestionIndex < questionlist.length - 1) ? 'Next' : 'Submit';
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(18),
          shape: StadiumBorder(),
        ),
        child: Text(buttonText),
        onPressed: () {
          setState(() {
            score++;
            if (currentQuestionIndex < questionlist.length - 1) {
              ++currentQuestionIndex;
              submitButtonVisibility = false;
            } else {
              if (score >= questionlist.length * 0.6)
                _showScoreDialog(true);
              else
                _showScoreDialog(false);
            }
          });
        },
      ),
    );
  }

  _showScoreDialog(bool isPassed) {
    String result = isPassed
        ? 'Congratulations!\nYou have passed the exam\nYour Score: ${score}'
        : 'Bad Luck!\nYou have failed the exam\nYour Score: ${score}';
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('RESULT'),
        content: Text(result),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                submitButtonVisibility = false;
                Navigator.pop(context);
              });
            },
            child: const Text('RESTART'),
          )
        ],
      ),
    );
  }
}
