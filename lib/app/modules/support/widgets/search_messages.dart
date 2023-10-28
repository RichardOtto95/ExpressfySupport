import 'package:delivery_support/app/modules/support/support_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../main/main_store.dart';

class SearchMessages extends StatefulWidget {
  final void Function(String)? onChanged;
  final FocusNode focusNode;

  const SearchMessages({Key? key, this.onChanged, required this.focusNode})
      : super(key: key);
  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  final MainStore mainStore = Modular.get();
  final SupportStore store = Modular.get();

  final TextEditingController textController = TextEditingController();

  bool searching = false;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        searching = true;
      } else {
        searching = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutQuart,
      width:
          searching ? maxWidth(context) - wXD(16, context) : wXD(68, context),
      height: wXD(41, context),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(17)),
        border: Border.all(color: darkGrey.withOpacity(.2)),
        color: backgroundGrey,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, offset: Offset(0, 3), color: Color(0x10000000)),
        ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Observer(builder: (context) {
          return InkWell(
            onTap: () {
              // print('searchFocus: ${searchFocus.hasFocus}');
              if (store.searchText == "") {
                if (!searching) {
                  widget.focusNode.requestFocus();
                } else {
                  widget.focusNode.unfocus();
                }
                setState(() => searching = !searching);
              } else {
                store.searchText = "";
                textController.text = "";
                widget.focusNode.unfocus();
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(17)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: searching ? wXD(65, context) : 0,
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOutQuart,
                    width: searching ? wXD(200, context) : 0,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: textController,
                      onChanged: widget.onChanged,
                      focusNode: widget.focusNode,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Buscar mensagens',
                        hintStyle: textFamily(
                          fontSize: 14,
                          color: const Color(0xff8F9AA2).withOpacity(.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: wXD(65, context),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: searching ? wXD(35, context) : 0),
                      child: Icon(
                        store.searchText == ""
                            ? Icons.search
                            : Icons.close_rounded,
                        size: wXD(26, context),
                        color: const Color(0xff8f9aa2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
