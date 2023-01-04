import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';

Widget defultTextFeild(
    {required TextEditingController controller,
    required TextInputType type,
    required String title,
    required IconData prefix,
    required Function validateFunction,
    required Function onTapFunction}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    validator: validateFunction(),
    onTap: onTapFunction(),
    decoration: InputDecoration(
        label: Text(title),
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder()),
  );
}

Widget defultButton(
    {required double width,
    required Color backGround,
    required Function function,
    required String text,
    bool isUpperCase = true,
    double radius = 0.0}) {
  return Container(
    width: width,
    child: MaterialButton(
      onPressed: function(),
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), color: backGround),
  );
}

Widget buildTaskItems(Map model, context) {
  return Dismissible(
    key: Key(model['Id'].toString()),
    child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['Time']}'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['Titel']}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${model['Date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )),
            // ignore: prefer_const_constructors
            SizedBox(
              width: 15.0,
            ),
            IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateData(Status: 'done', Id: model['Id']);
              },
            ),
            IconButton(
              icon: Icon(Icons.archive, color: Colors.black45),
              onPressed: () {
                AppCubit.get(context)
                    .updateData(Status: 'archive', Id: model['Id']);
              },
            )
          ],
        )),
    onDismissed: ((direction) =>
        AppCubit.get(context).DeleteData(Id: model['Id'])),
  );
}

Widget buildTaskCondtionBuilder({required List<Map> tasks}) {
  return ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItems(tasks[index], context),
            separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
            itemCount: tasks.length);
      },
      fallback: (context) => Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'No tasks yet,Please add some tasks',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          )));
}
