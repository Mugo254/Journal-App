import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journals_app/constants.dart';
import 'package:journals_app/models/event_model.dart';
import 'package:journals_app/screens/components/back_arrow_app_bar.dart';

class DetailsPage extends StatefulWidget {
  final Event eventDetails;
  const DetailsPage({super.key, required this.eventDetails});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: kDefaultPaddin / 2,
          left: kDefaultPaddin,
          right: kDefaultPaddin,
          bottom: kDefaultPaddin / 2,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eventDetails.title,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      DateFormat("dd MMM, yyyy")
                          .format(DateTime.parse(widget.eventDetails.date)),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (widget.eventDetails.image != null) ...[
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.file(
                          File(widget.eventDetails.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      widget.eventDetails.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Coming Soon",
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit_note,
                  color: kPrimaryColor,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
