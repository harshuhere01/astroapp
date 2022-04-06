import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.prefixIcon,
      required this.readOnly,
      this.ontapofeditText,
      required this.hint,
      this.ontapofsuffixicon,
      required this.validators,
      required this.keyboardTYPE,
      this.maxlength})
      : super(key: key);

  final TextEditingController controller;
  IconData prefixIcon;
  String hint;
  int? maxlength;
  bool readOnly;
  Function? ontapofsuffixicon;
  Function? ontapofeditText;
  TextInputType? keyboardTYPE;
  final FormFieldValidator<String> validators;

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => SizedBox(
        // height: 56,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: Colors.black,
                ),
          ),
          child: TextFormField(
            style: GoogleFonts.openSans(),
            readOnly: widget.readOnly,
            onTap: widget.hint == "DOB"
                ? () {
                    widget.ontapofeditText!();
                  }
                : null,
            controller: widget.controller,
            validator: widget.validators,
            maxLength: widget.maxlength,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),

              // helperText: 'Email',
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
              ),
              errorMaxLines: 4,
              labelText: widget.hint,
              labelStyle: GoogleFonts.openSans(fontSize: 16.0, color: Colors.grey),
              suffixIcon: widget.controller.text.isEmpty
                  ? Container(width: 0)
                  : widget.readOnly == true
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => widget.controller.clear(),
                        ),
            ),
            keyboardType: widget.keyboardTYPE,
            autofillHints: const [AutofillHints.email],
          ),
        ),
      );
}
