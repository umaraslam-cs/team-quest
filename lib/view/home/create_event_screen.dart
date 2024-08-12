import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/configs/extensions.dart';
import 'package:team_quest/configs/toast_message.dart';
import 'package:team_quest/configs/utils.dart';
import 'package:team_quest/services/firebase_storage_service.dart';
import 'package:team_quest/view/auth/widgets/login_button_widget.dart';
import 'package:team_quest/view/home/widgets/custom_input_field.dart';
import 'package:team_quest/view_model/home/home_view_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String imageURL = "";
  final eventNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    descriptionController.dispose();
    instructionsController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        ),
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: selectedDate ?? DateTime.now(),
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                selectedTime = TimeOfDay.fromDateTime(newTime);
              });
            },
          ),
        ),
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create a new Event',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            20.height,
            CustomInputField(
                hintText: "Team Sha79",
                labelText: "Event Name",
                controller: eventNameController),
            20.height,
            CustomInputField(
                hintText:
                    "A text area or rich text editor for entering detailed description for completing the task",
                labelText: "Description",
                maxLines: 2,
                controller: descriptionController),
            20.height,
            CustomInputField(
                hintText:
                    "A text area or rich text editor for entering detailed instructions for completing the task",
                labelText: "Instructions",
                maxLines: 2,
                controller: instructionsController),
            20.height,
            Row(
              children: [
                Expanded(child: dateOrTimeContainer('Select Date')),
                16.width,
                Expanded(child: dateOrTimeContainer('Select Time')),
              ],
            ),
            20.height,
            CustomInputField(
                hintText: "XXYYZZ",
                labelText: "Location",
                controller: locationController),
            8.0.height,
            Row(
              children: [
                const Icon(Icons.my_location, size: 20.0),
                8.0.width,
                TextButton(
                  onPressed: () {},
                  child: const Text('Use current location.',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            20.height,
            buildUploadButton(),
            if (imageURL.isNotEmpty) ...{
              10.height,
              Text(
                "Image URL: $imageURL",
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              ),
            },
            20.height,
            PrimaryButton(
                title: "Confirm & Next",
                onPress: () async {
                  if (eventNameController.value.text.isEmpty) {
                    ShowMessage.onError("Event name is required");
                    return;
                  } else if (descriptionController.value.text.isEmpty) {
                    ShowMessage.onError("Description is required");
                    return;
                  } else if (instructionsController.value.text.isEmpty) {
                    ShowMessage.onError("Instuctions are required");
                    return;
                  } else if (selectedDate == null) {
                    ShowMessage.onError("Please Select Date");
                    return;
                  } else if (selectedTime == null) {
                    ShowMessage.onError("Please Select Time");
                    return;
                  } else if (locationController.value.text.isEmpty) {
                    ShowMessage.onError("Location is required");
                    return;
                  } else if (imageURL.isEmpty) {
                    ShowMessage.onError("Please Upload Image");
                    return;
                  }

                  bool result = await Provider.of<HomeViewModel>(context,
                          listen: false)
                      .createEvent(
                          eventName: eventNameController.value.text,
                          description: descriptionController.value.text,
                          instructions: instructionsController.value.text,
                          location: locationController.value.text,
                          date: DateFormat('dd MMM yyyy')
                              .format(selectedDate!)
                              .toString(),
                          time:
                              '${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}',
                          imageUrl: imageURL);
                  if (result && context.mounted) {
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget buildTitleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildDateOrTimeField(String label) {
    return TextField(
      onTap: label == 'Select Date'
          ? () => _selectDate(context)
          : () => _selectTime(context),
      readOnly: true,
      decoration: InputDecoration(
        hintText: label,
        suffixIcon: const Icon(Icons.expand_more),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget dateOrTimeContainer(String label) {
    return GestureDetector(
      onTap: label == 'Select Date'
          ? () => _selectDate(context)
          : () => _selectTime(context),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.greyColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(
                  0,
                  2,
                ), // changes position of shadow
              ),
            ],
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(6.0)),
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label == 'Select Date' && selectedDate != null
                  ? DateFormat('dd MMM yyyy').format(selectedDate!).toString()
                  : label == 'Select Time' && selectedTime != null
                      ? '${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}'
                      : label,
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.greyColor,
              ),
            ),
            const Icon(
              Icons.expand_more,
              color: AppColors.greyColor,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget buildUploadButton() {
    return OutlinedButton(
      onPressed: () {
        Utils().showPicker(
            context: context,
            onGetImage: (value) async {
              Utils.showLoadingIndicator(context);
              String url = await FireStorageService()
                  .uploadImageToFirebase(context, value!.path, true);
              setState(() {
                imageURL = url;
              });
              Navigator.pop(context);
            });
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        child: Text('Upload Image', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
