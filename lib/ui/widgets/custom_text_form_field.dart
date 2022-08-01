import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithoutBorder extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final bool enable;
  final EdgeInsetsGeometry contentPadding;
  final TextCapitalization? textCapitalization;
  final String? Function(String? value)? validator;
  final bool readOnly;
  final Function()? onTap;

  TextFieldWithoutBorder(
      {required this.initialValue,
        required this.onChanged,
        this.keyboardType = TextInputType.text,
        this.textInputAction = TextInputAction.done,
        this.validator,
        this.minLines = 1,
        this.maxLines = 1,
        this.maxLength,
        this.errorText,
        this.inputFormatters,
        this.hintText,
        this.enable = true,
        this.contentPadding =
        const EdgeInsets.only(bottom: 11, top: 11, right: 15),
        this.textCapitalization,
        this.readOnly = false,
        this.onTap});

  @override
  _TextFieldWithoutBorderState createState() => _TextFieldWithoutBorderState();
}

class _TextFieldWithoutBorderState extends State<TextFieldWithoutBorder> {

  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textController.value =
        _textController.value.copyWith(text: widget.initialValue);
    return TextFormField(
      controller: _textController,
      autovalidateMode: AutovalidateMode.always,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      validator: widget.validator,
      enabled: widget.enable,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      enableInteractiveSelection: true,
      textCapitalization:
      widget.textCapitalization ?? TextCapitalization.characters,
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        errorText: widget.errorText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: widget.contentPadding,
      ),
    );
  }
}
