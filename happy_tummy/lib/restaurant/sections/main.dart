import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/restaurants.dart';
import 'package:happy_tummy/restaurant/sections/components/about_Section_text.dart';
import 'package:happy_tummy/restaurant/sections/components/about_text_with_sign.dart';
import 'package:happy_tummy/restaurant/sections/components/experience_card.dart';
import 'package:happy_tummy/restaurant/sections/constants.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';

final restaurantsReference = Firestore.instance.collection('restaurants');

class MainPage extends StatefulWidget {
  final String restaurantProfileId;

  MainPage({this.restaurantProfileId});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: restaurantsReference
                    .document(widget.restaurantProfileId)
                    .get(),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Splash();
                  }
                  Restaurant restaurant =
                      Restaurant.fromDocument(dataSnapshot.data);
                  return Column(children: [
                    //Top Section
                    Container(
                      alignment: Alignment.center,
                      constraints:
                          BoxConstraints(maxHeight: 200, minHeight: 100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/back1.jpg"),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: kDefaultPadding),
                        width: 300,
                        child: Stack(
                          children: [
                            //Blur BOx
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacer(),
                                //Glass Content
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding * 2),
                                      constraints: BoxConstraints(
                                          maxWidth: 1110,
                                          maxHeight: size.height * 0.7),
                                      width: double.infinity,
                                      color: Colors.white.withOpacity(0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Hello There!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(color: Colors.white),
                                          ),
                                          Text(
                                            "${restaurant.name} \n${restaurant.location}",
                                            style: TextStyle(
                                              fontSize: 70,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            '2020/18/09',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 639, maxHeight: 860),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("assets/images/trisara.jpeg"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    //About SEction
//                    Container(
//                      margin:
//                          EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
//                      constraints: BoxConstraints(maxWidth: 1110),
//                      child: Column(
//                        children: [
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                              AboutTextWithSign(),
//                              Expanded(
//                                child: AboutSectionText(
//                                    text:
//                                        'Cusines : ${restaurant.cusines}\nMeal type : ${restaurant.mealtype}\nOutlet Type : ${restaurant.outlettype}'),
//                              ),
//                              ExperienceCard(
//                                  numOfExp:
//                                      "${(DateTime.now().year - restaurant.age.toDate().year).toString()}"),
//                              Expanded(
//                                child: AboutSectionText(
//                                    text:
//                                        "Additional Info\nParking : ${restaurant.parking}\nPayment Method : ${restaurant.paymentmethod}\nBillingExtra : ${restaurant.billingextra}"),
//                              ),
//                            ],
//                          ),
//                          SizedBox(height: kDefaultPadding * 3),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              FlatButton.icon(
//                                shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(50)),
//                                color: Color(0xFFE8F0F9),
//                                icon: Icon(Icons.edit),
//                                label: Text('Edit Profile'), //`Text` to display
//                                onPressed: () {},
//                              ),
//                              SizedBox(
//                                width: 30,
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
                  ]);
                }),
            //FeedbackSection(),
            SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}