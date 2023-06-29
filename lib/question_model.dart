class Question {
  final String questionText;
  final int questionPhotoIndex;
  final List<Answer> answerList;

  Question(this.questionText, this.questionPhotoIndex, this.answerList);
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer(this.answerText, this.isCorrect);
}

List<Question> getQuestions() {
  List<Question> list = [];

  list.add(
    Question(
      'What does this sign mean?',
      1,
      [
        Answer('Hump Bridge', false),
        Answer('Humps in the road', true),
        Answer('Entrance to tunnel', false),
        Answer('Soft Verges', false),
      ],
    ),
  );
  list.add(
    Question(
      'What does this sign mean?',
      2,
      [
        Answer('Hump Bridge', false),
        Answer('Humps in the road', false),
        Answer('Entrance to tunnel', false),
        Answer('Soft Verges', true),
      ],
    ),
  );
  list.add(
    Question(
      'What does this sign mean?',
      2,
      [
        Answer('Hump Bridge', true),
        Answer('Humps in the road', false),
        Answer('Entrance to tunnel', true),
        Answer('Soft Verges', false),
      ],
    ),
  );
  return list;
}
