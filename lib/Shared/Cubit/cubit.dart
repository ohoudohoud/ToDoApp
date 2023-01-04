// ignore_for_file: non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Modules/archive-tasks.dart';
import 'package:todoapp/Modules/done-tasks.dart';
import 'package:todoapp/Shared/Cubit/States.dart';

import '../../Modules/new-tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  late Database todoDatabase;
  static AppCubit get(context) => BlocProvider.of(context);
  int currantIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived'];
  void changeIndex(int index) {
    currantIndex = index;
    emit(AppChangeBottomBarState());
  }

  void changeBottomsheet({required bool isShow, required IconData Icon}) {
    isBottomSheetShown = isShow;
    fabIcon = Icon;
    emit(AppChangeBottomSSheetState());
  }

  createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (todoDatabase, version) {
        todoDatabase
            .execute(
                'Create table Tasks(Id INTEGER PRIMARY KEY ,Titel Text, Date Text , Time Text ,Status Text )')
            .then((value) {
          print('done table');
        }).catchError((onError) {
          print("${onError}");
        });
      },
      onOpen: (todoDatabase) {
        getDataFromDatabase(todoDatabase);
        emit(AppGetDataBaseState());
      },
    ).then((value) {
      todoDatabase = value;
      emit(AppCreateDataBaseState());
    });
  }

  void getDataFromDatabase(todoDatabase) {
    emit(AppGetDataBaseLodingState());
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    todoDatabase.rawQuery('SELECT * From Tasks').then((value) {
      value.forEach((element) {
        if (element['Status'] == 'NEW') newTasks.add(element);
        if (element['Status'] == 'done') doneTasks.add(element);
        if (element['Status'] == 'archive') archiveTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  Future insertToDatabase(
      {required String title, required String date, required String time}) {
    return todoDatabase.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Tasks(Titel, Date, Time,Status) VALUES("$title","$date","$time","NEW")')
          .then((value) {
        print('$value done row');
        emit(AppInsertDataBaseState());
        getDataFromDatabase(todoDatabase);
        emit(AppGetDataBaseState());
      }).catchError((onError) {
        print("${onError}");
      });
      return null;
    });
  }

  void updateData({required String Status, required int Id}) async {
    await todoDatabase.rawUpdate('UPDATE Tasks SET Status = ? WHERE Id = ?',
        ['$Status', Id]).then((value) {
      getDataFromDatabase(todoDatabase);
      emit(AppUpdateDataBaseState());
    });
  }

  void DeleteData({required int Id}) async {
    await todoDatabase
        .rawDelete('DELETE FROM Tasks  WHERE Id = ?', [Id]).then((value) {
      getDataFromDatabase(todoDatabase);
      emit(AppDeleteDataBaseState());
    });
  }
}
