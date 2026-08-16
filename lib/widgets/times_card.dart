import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimesCard extends StatefulWidget {
  const TimesCard({
    super.key,
    required this.title,
    required this.textController,
  });
  final String title;
  final TextEditingController textController;

  @override
  State<TimesCard> createState() => _TimesCardState();
}

class _TimesCardState extends State<TimesCard> {
  @override
  void initState() {
    super.initState();
    widget.textController.text = '0';
  }

  @override
  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          //  SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 2,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required maxLength,
                      required isFocused,
                    }) {
                      return const SizedBox();
                    },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                controller: widget.textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
