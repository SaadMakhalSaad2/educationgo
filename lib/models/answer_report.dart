class AnswerReport {
  String questionId;
  String userId;

  int score;

  AnswerReport(this.questionId, this.userId, this.score);

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'userId': userId,
        'score': score,
      };
}
