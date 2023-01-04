import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/Components.dart';
import 'package:todoapp/Shared/Cubit/States.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';

import '../Shared/constants.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return buildTaskCondtionBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
