part of 'doc_bloc.dart';

@immutable
sealed class DocEvent {}

class DocSendEvent extends DocEvent {

  String name;
  String date;
  String slipno;
  String age;
  String sex;
  String referredby;
  String filename;
  String mainfile;

  DocSendEvent({
    required this.name,
    required this.date,
    required this.slipno,
    required this.age,
    required this.sex,
    required this.referredby,
    required this.filename,
    required this.mainfile,
});

}
