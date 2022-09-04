import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController UpdateController = TextEditingController();

  Box? mybox;

  @override
  void initState() {
    mybox = Hive.box("myList");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  var country = nameController.text;
                  await mybox!.add(country);
                },
                child: Text("Add Data")),
            SizedBox(
              height: 32,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: Hive.box("myList").listenable(),
              builder: (context, Box, wwidget) {
                return ListView.builder(
                    itemCount: mybox!.keys.toList().length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 10.0,
                        child: ListTile(
                          title: Text(mybox!.getAt(index).toString()),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        UpdateController,
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        mybox!.putAt(
                                                            index,
                                                            UpdateController
                                                                .text);
                                                      },
                                                      child: Text("Update")),
                                                  SizedBox(
                                                    height: 32,
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      mybox!.deleteAt(index);
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }
}
