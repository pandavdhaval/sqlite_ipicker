import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_ipicker/controllerr/to_model.dart';

import 'controllerr/home_page_controller.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ImagePicker picker =ImagePicker();
  // XFile? image;
  var homePageController = Get.put(HomePageController());
  // TextEditingController imageController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descreptionController = TextEditingController();
  final _formkey =GlobalKey<FormState>();

  RxString imageshow="".obs;

  List<int> items=List.generate(20, (index) =>index);
  @override
  void initState() {
    dateController!.text="";
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Image Date Picker'),
      ),

      body: Obx(() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount:homePageController.todolist.length,
          itemBuilder: (context,index){
            return Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
              ),
            child: Dismissible(
            background: Container(
            color: Colors.red,
            ),

            key: ValueKey<int>(items[index]),
            onDismissed: (DismissDirection direction) {
              homePageController.deleteTodo(id:homePageController.todolist[index].id!);

            },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 35,
                    backgroundImage: FileImage(File("${homePageController.todolist[index].image}")),
                    ),

                    SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${homePageController.todolist[index].id}"),
                        Text("${homePageController.todolist[index].name}"),
                        Text("${homePageController.todolist[index].desc}"),
                        Text("${homePageController.todolist[index].date}"),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: ()async{
                          await buildShowModalBottomSheet(context,isUpdate:true,id:homePageController.todolist[index].id);
                          nameController.text=homePageController.todolist[index].name!;
                          descreptionController.text=homePageController.todolist[index].desc!;
                          dateController.text=homePageController.todolist[index].date!;


                        },
                        child: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
            );
          }, separatorBuilder: (context,index){return SizedBox(height: 5,);},),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(Icons.perm_identity_rounded),
        onPressed: ()async{
         await buildShowModalBottomSheet(context,isUpdate:false);
        },
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context,{required bool isUpdate,  String? id}) async {
    showModalBottomSheet(context: context,
           builder: (context){
         return SingleChildScrollView(
           child: Container(
             height: 600,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Form(
                 key: _formkey,
                 child: Column(
                   children: [
                     Obx(() => CircleAvatar(
                       radius: 50,
                       backgroundColor: Colors.grey,
                       child:ClipOval(
                         child: imageshow.value != ""
                             ?Image.file(File(imageshow.value),fit: BoxFit.cover,width: 100,):

                         GestureDetector(
                           //    onTap: () async {
                           //      final XFile? image=
                           // await  picker.pickImage(source: ImageSource.gallery);
                           //      picker.pickImage(source: ImageSource.camera);
                           //      setState(() {
                           //        imageshow =File(image!.path);
                           //        print("imgesssss");
                           //
                           //      });
                           //    },

                             onTap: (){
                               showModalBottomSheet(context: context, builder: (context){
                                 return Container(
                                   height: 15.h,
                                   color: Colors.black54,
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 15,left: 15),
                                     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("Profile Photo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                         SizedBox(height: 2.h,),
                                         Row(
                                           children: [
                                             TextButton(onPressed: ()async{
                                               final XFile? image=
                                               await picker.pickImage(source: ImageSource.camera);
                                               imageshow.value=image!.path;

                                               Navigator.pop(context);
                                             }, child:   Icon(Icons.camera_alt_outlined,size: 30,),),

                                             TextButton(onPressed: ()async{
                                               final XFile? image=
                                               await picker.pickImage(source: ImageSource.gallery);
                                               imageshow.value=image!.path;
                                               Navigator.pop(context);
                                             }, child:   Icon(Icons.image,size: 30,),),

                                             TextButton(onPressed: (){
                                               // final XFile? image=
                                               // await picker.pickImage(source: ImageSource.gallery);
                                               setState(() {
                                                 // imageshow=File(image!.path);
                                                 imageCache.clear();
                                               });
                                               Navigator.pop(context);
                                             }, child:   Icon(Icons.delete,size: 30,),),

                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 );
                               });
                             },
                             child: Icon(Icons.add_a_photo_outlined,color: Colors.white,)),
                       ),

                     ),),
                     SizedBox(height: 10,),

                     TextFormField(
                       controller: nameController,
                       validator:(v){
                         if(v!.isEmpty){
                           return "enter user name";
                         }
                       },
                       decoration: InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         hintText: "Name",
                       ),
                     ),

                     SizedBox(height: 10,),

                     TextFormField(

                       controller: descreptionController,
                       validator:(v){
                         if(v!.isEmpty){
                           return "descreption";
                         }
                       },
                       decoration: InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         hintText: "descreption",
                       ),
                     ),
                         SizedBox(height: 10,),

                     TextFormField(
                       onTap: () async {
                         DateTime? pickedDate =
                             await showDatePicker(context: context, initialDate: DateTime.now(),
                           firstDate: DateTime(2000),
                           lastDate: DateTime(2050),
                         );
                         if(pickedDate != null){
                           String formatedDate =
                           DateFormat("dd-MM-yyyy").format(pickedDate);
                           setState(() {
                             dateController!.text =formatedDate.toString();
                           });
                         }
                       },
                       controller: dateController,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         hintText: "Enter Date",
                         labelText: "Date",
                       ),
                     ),
                     SizedBox(height: 10,),

                     ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           primary: Colors.grey,
                         ),
                         onPressed: (){
                       if(_formkey.currentState!.validate()){
                         if(isUpdate==false){
                         homePageController.addData(image:imageshow.value, name:nameController.text, desc:descreptionController.text, date: dateController.text);

                         }
                         else{
                           // print("ID::$id Name:${nameController.text} Desc:::${descreptionController.text} DAte:::${dateController.text}");
                            homePageController.updateTodo(ToModel(id: id!,image:imageshow.value, date: dateController.text,desc: descreptionController.text,name: nameController.text,));

                         }
                         Navigator.pop(context);
                         nameController.clear();
                         descreptionController.clear();
                         dateController.clear();
                       }
                     },
                         child:Text("save"))
                   ],
                 ),
               ),
             ),
           ),

         );
       });
  }
}
