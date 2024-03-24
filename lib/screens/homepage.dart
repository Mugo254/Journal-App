import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:journals_app/constants.dart';
import 'package:journals_app/screens/date_select_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/journal_bg.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 45,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin * 1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPaddin),
                  color: Colors.white.withOpacity(.3),
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultPaddin),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const Text(
                            "World of my words",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Memories are the most beautiful gift someone could give to its future self.",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: kDefaultPaddin),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddin * 2,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalenderView(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: kPrimaryColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Start Journaling",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
