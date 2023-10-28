import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_support/app/shared/widgets/side_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../customers_store.dart';

class CreateCoupon extends StatefulWidget {
  const CreateCoupon({Key? key}) : super(key: key);

  @override
  _CreateCouponState createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final CustomersStore store = Modular.get();
  OverlayEntry? overlayEntry;
  final _formKey = GlobalKey<FormState>();
  bool isPercentOff = true;
  num? percentOff;
  num? valueOff;
  num? valueMinimum;
  String? code;
  String? text;
  TextEditingController textEditingController = TextEditingController();

  MaskTextInputFormatter percentMask = MaskTextInputFormatter(
    mask: '### %', filter: {"#": RegExp(r'[0-9]')});

  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(symbol: 'R\$');

  final CurrencyTextInputFormatter _currencyFormatter2 =
      CurrencyTextInputFormatter(symbol: 'R\$');

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        height: wXD(140, context),
        text: 'Tem certeza em cancelar? \nSeu anúncio será descartado!',
        onConfirm: () {},
        onCancel: () {
          overlayEntry!.remove();
          overlayEntry = null;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.cleanCache();
        return true;
      },
      child: Listener(
        onPointerDown: (a) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: backgroundGrey,
          body: Observer(builder: (context) {
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      wXD(30, context),
                      wXD(15, context),
                      wXD(20, context),
                      0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(50, context)),
                        CouponTypeDropDown(
                          callBack: (bool value){
                            if (kDebugMode) {
                              print('callback click');
                            }
                            setState(() {
                              valueOff = null;
                              percentOff = null;
                              textEditingController.clear();
                              isPercentOff = value;
                            });
                          },
                        ),
                        SizedBox(height: wXD(20, context)),
                        TextInput(
                          textEditingController: textEditingController,
                          title: isPercentOff ? "Percentual off*" : "Valor off*",
                          hint: isPercentOff ? "20%" : "20,00R\$",
                          currencyFormatter: isPercentOff ? null : _currencyFormatter,
                          maskFormatterList: isPercentOff ? [percentMask] : [],
                          textInputType: TextInputType.number,
                          onChanged: (String value){
                            if(isPercentOff){
                              if(percentMask.getUnmaskedText() != ""){
                                percentOff = num.parse(percentMask.getUnmaskedText());
                              } else {
                                percentOff = null;
                              }
                            } else {
                              valueOff = _currencyFormatter.getUnformattedValue();
                            }
                          },
                          validator: (String? value){
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }

                            if(isPercentOff){
                              num valueInt = num.parse(percentMask.getUnmaskedText());

                              if(valueInt > 100){
                                return "Valor máximo é 100";
                              }

                            }
                            return null;
                          },
                        ),
                        SizedBox(height: wXD(20, context)),
                        TextInput(
                          title: "Código para o cupom*",
                          hint: "EX2022",
                          onChanged: (String value){
                            code = value;
                          },
                          validator: (String? value){
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: wXD(20, context)),
                        TextInput(
                          title: "Texto do cupom*",
                          hint: "Cupom de primeiro pedido",
                          onChanged: (String value){
                            text = value;
                          },
                          validator: (String? value){
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: wXD(20, context)),
                        TextInput(
                          currencyFormatter: _currencyFormatter2,
                          textInputType: TextInputType.number,
                          title: "Valor mínimo",
                          hint: "Valor mínimo para o cupom",
                          onChanged: (String value){
                            valueMinimum = _currencyFormatter2.getUnformattedValue();
                          },
                        ),
                        SizedBox(height: wXD(100, context)),
                      ],
                    ),
                  ),
                ),
                DefaultAppBar(
                  'Criar cupom',
                  onPop: () {
                    store.cleanCache();
                    Modular.to.pop();
                  },
                ),
                Positioned(
                  right: 0,
                  bottom: wXD(30, context),
                  child: SideButton(
                    onTap: () {
                      if(_formKey.currentState!.validate()){
                        store.saveData(
                          code: code!,
                          discountOff: valueOff,
                          percentOff: percentOff,
                          text: text!,
                          valueMinimum: valueMinimum,
                        );
                      }
                    },
                    height: wXD(52, context),
                    width: wXD(142, context),
                    title: 'Criar',
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class CouponTypeDropDown extends StatefulWidget {
  final Function(bool) callBack;
  const CouponTypeDropDown({
    Key? key, 
    required this.callBack,
  }) : super(key: key);

  @override
  State<CouponTypeDropDown> createState() => _CouponTypeDropDownState();
}

class _CouponTypeDropDownState extends State<CouponTypeDropDown> {
  String dropdownValue = 'Percentual off';
  List<String> valuesList = ["Percentual off", "Valor off"];

  @override
  Widget build(BuildContext context){
     return SizedBox(
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             'Tipo de cupom',
             style: textFamily(
               fontSize: 15,
               color: darkGrey,
             ),
           ),
           DropdownButton<String>(
             value: dropdownValue,
             icon: const Icon(Icons.arrow_downward),
             elevation: 16,
             style: const TextStyle(color: darkGrey),
             underline: Container(
               height: 2,
               color: primary,
             ),
             onChanged: (String? newValue) {
               setState(() {
                 dropdownValue = newValue!;
                 widget.callBack(newValue == "Percentual off");
               });
             },
             items: valuesList
                 .map<DropdownMenuItem<String>>((String value) {
               return DropdownMenuItem<String>(
                 value: value,
                 child: Text(value),
               );
             }).toList(),
           ),
         ],
       ),
     );
  }
}

class TextInput extends StatefulWidget {
  final String title;
  final String hint;
  final CurrencyTextInputFormatter? currencyFormatter;
  final List<MaskTextInputFormatter>? maskFormatterList;
  final Function(String) onChanged;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;

  const TextInput({
    Key? key,
    required this.title,
    required this.hint,
    this.currencyFormatter,
    this.maskFormatterList,
    required this.onChanged, 
    this.textEditingController,
    this.textInputType, 
    this.validator,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            child: Text(
              widget.title,
              style: textFamily(
                fontSize: 15,
                color: totalBlack,
              ),
            ),
        ),
        Center(
          child: Container(
            height: wXD(52, context),
            width: wXD(342, context),
            decoration: BoxDecoration(
              color: white,
              border: Border.all(color: primary),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
            child: TextFormField(
              keyboardType: widget.textInputType,
              controller: widget.textEditingController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: widget.currencyFormatter != null ? [widget.currencyFormatter!] : widget.maskFormatterList,
              // focusNode: titleFocus,
              validator: widget.validator,
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
              ),
              onChanged: widget.onChanged,
              // onEditingComplete: () => descriptionFocus.requestFocus(),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }
}
