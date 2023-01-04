import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Shared/Cubit/States.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';

import '../Shared/constants.dart';

class HomeLayout extends StatelessWidget {
  late Database todoDatabase;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleControllor = TextEditingController();
  var dateControllor = TextEditingController();
  var timeControllor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is AppInsertDataBaseState) Navigator.pop(context);
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currantIndex]),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDataBaseLodingState,
            builder: (context) => cubit.screens[cubit.currantIndex],
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titleControllor.text,
                      date: dateControllor.text,
                      time: timeControllor.text);
                }
              } else {
                print('object');
                scaffoldKey.currentState!
                    .showBottomSheet(
                        (context) => Container(
                            padding: const EdgeInsets.all(20.0),
                            color: Colors.white,
                            child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                        controller: titleControllor,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Task title is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.title),
                                            label: Text('Task Title'),
                                            border:
                                                const OutlineInputBorder())),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                        controller: dateControllor,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2050-12-30'))
                                              .then((value) =>
                                                  dateControllor.text =
                                                      DateFormat.yMMMd()
                                                          .format(value!));
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Task date is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.date_range_sharp),
                                            label: Text('Task Date'),
                                            border:
                                                const OutlineInputBorder())),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                        controller: timeControllor,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) =>
                                                  timeControllor.text = value!
                                                      .format(context)
                                                      .toString());
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Task time is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.watch_later_outlined),
                                            label: Text('Task Time'),
                                            border:
                                                const OutlineInputBorder())),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ))),
                        elevation: 20.0)
                    .closed
                    .then((value) {
                  cubit.changeBottomsheet(isShow: false, Icon: Icons.edit);
                });
                cubit.changeBottomsheet(isShow: true, Icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currantIndex,
            onTap: (index) {
              /* setState(() {
            currantIndex = index;
          }); */
              cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived')
            ],
          ),
        );
      }),
    );
  }
}
