import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_friend/map_list_screen/map_list_screen.dart';
import 'package:my_friend/mep_screen.dart';

import '../user.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int currentPage = 0;
  List<String> list = [
    "https://i.pinimg.com/564x/a4/dd/b8/a4ddb8c690b7156a54e013a4bc8dadfa.jpg",
    "https://i.pinimg.com/564x/86/46/5b/86465b2aad64756561e7a3fa3adf76ae.jpg",
    "https://i.pinimg.com/564x/6e/21/ea/6e21ea2656e1c7c7f44a2aa28405431d.jpg"
  ];
  String m="";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppUser>>(
      stream: contactStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final contacts = snapshot.data ?? [];



        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Row(
              children: [
                Expanded(
                  child: Column(),
                  flex: 1,
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListMapScreen(
                                  list: snapshot.data ?? [],
                                ),
                              ),
                            );
                          },
                          child: Icon(Icons.my_location_outlined,color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                CarouselSlider(
                  items: list.map((i) {
                    return Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Image.network(
                        i,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                    onPageChanged: (value, _) {

                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: contacts.length,
                  itemBuilder: (_, index) {

                    final contact = contacts[index];
                    m=(index+1).toString();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              long: contact.long,
                              lat: contact.lat,
                              image: contact.image,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [



                                  Flexible(flex: 1,child:   Column(
                                    children: [

                                      Container(
                                        margin: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 0),
                                        child:  Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.my_location_outlined),
                                              ],
                                            ),
                                            SizedBox(width: 4,),
                                            Row(
                                              children: [

                                                Text("Corrida${index+1}",style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff003154),
                                                  fontWeight: FontWeight.bold
                                                ),),
                                              ],
                                            ),
                                        
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8,right: 8,top: 0,bottom: 4),
                                        child: Row(
                                          children: [
                                            Text(contact.name,
                                            style: TextStyle(
                                              fontSize: 16,fontWeight: FontWeight.bold
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),)
                                ,


                                  Flexible(flex: 1,child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: ClipOval(
                                          child: Image.network(
                                            contact.image,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),)

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Stream<List<AppUser>> contactStream() => FirebaseFirestore.instance
      .collection('user')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((e) => AppUser.fromJson(e.data(), e.id)).toList());
}
