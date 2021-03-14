import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.cyan,
      ),
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String studentName,studentID,programID;
  double studentGPA;

  ///TextField Data ============================================================
  getStudentName(name){
    this.studentName = name;
  }
  getStudentID(id){
    this.studentID = id;
  }
  getProgramID(pid){
    this.programID = pid;
  }
  getStudentGPA(gpa){
    this.studentGPA = double.parse(gpa);
  }

  ///Button Click Functions ====================================================
  createData(){
    print("created");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String,dynamic> students = {
      "studentName" : studentName,
      "studentID" : studentID,
      "programID" : programID,
      "gpa" : studentGPA
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName created");
    });

  }
  readData(){
    print("read");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.get().then((datasnapshot){
      print(datasnapshot.get("studentName"));
      print(datasnapshot.get("studentID"));
      print(datasnapshot.get("programID"));
      print(datasnapshot.get("gpa"));
    });
  }
  updateData(){
    print("updated");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String,dynamic> students = {
      "studentName" : studentName,
      "studentID" : studentID,
      "programID" : programID,
      "gpa" : studentGPA
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName Updated");
    });
  }
  deleteData(){
    print("deleted");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.delete().whenComplete(() {
      print("$studentName Deleted Successfully");
    });
  }

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Fire App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0
                    )
                  )
                ),
                onChanged: (String name){
                  getStudentName(name);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Student ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0
                        )
                    )
                ),
                onChanged: (String id){
                  getStudentID(id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Program ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0
                        )
                    )
                ),
                onChanged: (String pid){
                  getProgramID(pid);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "GPA",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0
                        )
                    )
                ),
                onChanged: (String gpa){
                  getStudentGPA(gpa);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text("Create"),
                  textColor: Colors.white,
                  onPressed: (){
                    createData();
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text("Read"),
                  textColor: Colors.white,
                  onPressed: (){
                    readData();
                  },
                ),
                RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text("Update"),
                  textColor: Colors.white,
                  onPressed: (){
                    updateData();
                  },
                ),
                RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text("Delete"),
                  textColor: Colors.white,
                  onPressed: (){
                    deleteData();
                  },
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Student Name",style: TextStyle(fontWeight: FontWeight.w700),),
                  ),
                  Expanded(
                    child: Text("Student ID",style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                    child: Text("Program ID",style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                    child: Text("GPA",style: TextStyle(fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
            DividerLine(),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("MyStudents").snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("${documentSnapshot.get("studentName")}"),
                              ),
                              Expanded(
                                child: Text("${documentSnapshot.get("studentID")}"),
                              ),
                              Expanded(
                                child: Text("${documentSnapshot.get("programID")}"),
                              ),
                              Expanded(
                                child: Text("${documentSnapshot.get("gpa")}"),
                              )
                            ],
                          ),
                          DividerLine(),
                        ],
                      );
                    },
                  );
                }
                else{
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Container(
        height: 1,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(.1),
      ),
    );
  }
}



