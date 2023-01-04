import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/Components.dart';
import 'package:todoapp/Shared/Cubit/States.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';

import '../Shared/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return buildTaskCondtionBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
