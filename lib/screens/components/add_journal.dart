import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journals_app/constants.dart';
import 'package:journals_app/models/event_model.dart';

import 'package:journals_app/screens/components/back_arrow_app_bar.dart';
import 'package:journals_app/utils.dart';

class AddJournal extends StatefulWidget {
  final String pickedDate;
  final ValueNotifier<List<Event>> selectedEvents;
  final DateTime nonFormattedSelectedDate;
  final VoidCallback getAllEvents;

  const AddJournal(
      {super.key,
      required this.pickedDate,
      required this.selectedEvents,
      required this.nonFormattedSelectedDate,
      required this.getAllEvents});

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  String? selectedImage;
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.16,
                              child: ListView(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                    ),
                                    title: const Text(
                                      "Camera",
                                      style: TextStyle(fontFamily: "Axiforma"),
                                    ),
                                    onTap: () async {
                                      var imagePicker = ImagePicker();
                                      Navigator.pop(context);
                                      final XFile? cameraImage =
                                          await imagePicker.pickImage(
                                        source: ImageSource.camera,
                                      );
                                      setState(() {
                                        selectedImage = cameraImage!.path;
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.photo_album,
                                      color: Colors.black,
                                    ),
                                    title: const Text(
                                      "Gallery",
                                      style: TextStyle(fontFamily: "Axiforma"),
                                    ),
                                    onTap: () async {
                                      var imagePicker = ImagePicker();
                                      Navigator.pop(context);
                                      final XFile? galleryImage =
                                          await imagePicker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      setState(() {
                                        selectedImage = galleryImage!.path;
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: selectedImage != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                File(selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: kPrimaryColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Pick Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const Text(
                    "Event Title",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Axiforma',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPaddin / 2,
                            top: kDefaultPaddin / 1.3,
                            bottom: kDefaultPaddin / 1.3,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return 'Event Title cannot be empty';
                              }

                              return null;
                            },
                            controller: titleController,
                            cursorColor: kPrimaryColor,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Event Title",
                            ),
                            style: const TextStyle(
                              fontFamily: 'Axiforma',
                              fontSize: 14,
                              color: Colors.black,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  const Text(
                    "Event Decription",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Axiforma',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPaddin / 2,
                            top: kDefaultPaddin / 1.3,
                            bottom: kDefaultPaddin / 1.3,
                          ),
                          child: TextFormField(
                            cursorColor: kPrimaryColor,
                            maxLines: 6,
                            controller: descriptionController,
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return 'Event Title cannot be empty';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Start Journaling",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  await FirebaseFirestore.instance.collection('journal').add({
                    'description': descriptionController.text.trim(),
                    'image': selectedImage,
                    'title': titleController.text.trim(),
                    'date': widget.pickedDate,
                  });
                  final eventsForSelectedDay =
                      await getEventsForDay(widget.nonFormattedSelectedDate);

                  widget.selectedEvents.value = eventsForSelectedDay;
                  // widget.getAllEvents();
                  // Go Back to the select date page
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "Journal Added Successfully",
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  setState(() {
                    isLoading = false;
                  });
                } catch (e) {
                  if (kDebugMode) {
                    print('Error Creating events for day: $e');
                  }

                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "An Error Occured During Event Creation",
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                      : const Text(
                          "Add Journal",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
