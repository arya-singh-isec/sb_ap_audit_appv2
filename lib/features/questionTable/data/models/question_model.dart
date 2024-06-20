import '../../domain/entities/question.dart';


class QuestionModel extends Question {
  QuestionModel ({
    required  String questionNo,
    required  String subBroker,
    required  String reviewer,
    required  String corporate,
  }):super(
      questionNo: questionNo,
      subBroker: subBroker,
      reviewer: reviewer,
      corporate: corporate
  );


  factory QuestionModel.fromJson(Map<String,dynamic>json){
    return QuestionModel(questionNo: json['questionNo'], 
                          subBroker: json['subBroker'], 
                          reviewer: json['reviewer'], 
                          corporate: json['corporate']
                          );
  }

  Map<String,dynamic> toJson(){
    return {
      'questionNo': questionNo, 
                          'subBroker': subBroker, 
                          'reviewer': reviewer, 
                          'corporate':corporate
    };
  }
}