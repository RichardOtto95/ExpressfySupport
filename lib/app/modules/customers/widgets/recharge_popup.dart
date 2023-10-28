import 'dart:ui';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/widgets/confirm_popup.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import '../customers_store.dart';

class RechargePopUp extends StatelessWidget {
  final String text;
  final void Function() onCancel;
  final String customerId;
  // final Function(num) onConfirm;
  // final Function(num) onChanged;
  final double? height;
  RechargePopUp({
    Key? key,
    required this.text,
    required this.customerId,
    // required this.onConfirm,
    required this.onCancel,
    this.height, 
    // required this.onChanged,
  }) : super(key: key);

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');
  final CustomersStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Container(
              height: maxHeight(context),
              width: maxWidth(context),
              color: totalBlack.withOpacity(.6),
              alignment: Alignment.center,
              // child: 
            ),
          ),
          Material(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
            child: Container(
              height: height ?? wXD(175, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
                boxShadow: [BoxShadow(blurRadius: 18, color: totalBlack)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: textFamily(fontSize: 17),
                  ),
                  Container(                      
                    // height: wXD(30, context),
                    // width: wXD(171, context),
                    // decoration: BoxDecoration(
                    //   color: white,
                    //   border: Border.all(color: primary),
                    //   borderRadius: const BorderRadius.all(Radius.circular(12)),
                    // ),
                    // padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
                    margin: EdgeInsets.symmetric(vertical: wXD(10, context)),
                    child: TextFormField(
                      inputFormatters: [_formatter],
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (kDebugMode) {
                          print('val price: $val');
                        }
                        
                        if (val == null || val.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Digite o valor da recarga',
                      ),
                      onChanged: (String val) {
                        if (kDebugMode) {
                          print('price: ${_formatter.getUnformattedValue()}');
                        }
                        store.value = _formatter.getUnformattedValue();
                      },
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlackButton(text: 'Cancelar', onTap: onCancel),
                      SizedBox(width: wXD(14, context)),
                      BlackButton(text: 'Pronto', onTap: (){
                        // num value = _formatter.getUnformattedValue();
                        if (kDebugMode) {
                          // print('_formKey.currentState: ${_formKey.currentState}');
                          print('value: ${store.value}');
                        }
                        // if(_formKey.currentState!.validate()){
                        if(store.value != 0){
                          store.overlayConfirm =
                            OverlayEntry(builder: (context) => ConfirmPopup(
                              text: "Tem certeza que deseja recarregar ${formatedCurrency(store.value)}R\$  ?",
                              onCancel: () {
                                store.overlayConfirm!.remove();
                                store.overlayConfirm = null;
                              },
                              onConfirm: () async{
                                store.overlayLoad =
                                  OverlayEntry(builder: (context) => const LoadCircularOverlay());

                                Overlay.of(context)?.insert(store.overlayLoad!);
                                await store.rechargeUser(customerId);

                                // overlayRecharge!.remove();
                                store.overlayConfirm!.remove();
                                store.overlayLoad!.remove();
                                store.overlayConfirm = null;
                                store.overlayLoad = null;
                                onCancel();
                              },
                            ));
                          Overlay.of(context)!.insert(store.overlayConfirm!);
                          // onConfirm(value);
                        }
                        // }
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlackButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final double width;
  const BlackButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = 82,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: wXD(47, context),
          width: wXD(width, context),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: totalBlack,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textFamily(color: primary, fontSize: 17),
          )),
    );
  }
}
