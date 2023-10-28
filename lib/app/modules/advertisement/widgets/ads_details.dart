import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;
import '../advertisement_store.dart';

class AdsDetails extends StatefulWidget {
  AdsDetails({Key? key}) : super(key: key);

  @override
  _AdsDetailsState createState() => _AdsDetailsState();
}

class _AdsDetailsState extends State<AdsDetails> {
  final AdvertisementStore store = Modular.get();

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');

  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // print('isEditing: ${store.editingAd}');
    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: wXD(17, context), bottom: wXD(9, context)),
            child: Text('Título do anúncio*',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
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
                initialValue:
                    store.editingAd ? store.adEdit.title : store.adsTitle,
                focusNode: titleFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Escreva um título válido';
                  }
                  return null;
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ex: Samsung Galaxy S9',
                ),
                onChanged: (val) {
                  // print('title: $val');
                  store.editingAd
                      ? store.adEdit.title = val
                      : store.setAdsTitle(val);
                },
                onEditingComplete: () => descriptionFocus.requestFocus(),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Descrição*',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
          ),
          Center(
            child: Container(
              height: wXD(123, context),
              width: wXD(342, context),
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: primary),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: wXD(12, context),
                vertical: wXD(20, context),
              ),
              alignment: Alignment.topLeft,
              child: TextFormField(
                initialValue: store.editingAd
                    ? store.adEdit.description
                    : store.adsDescription,
                focusNode: descriptionFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Escreva uma descrição válida';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration.collapsed(
                  hintText:
                      'Ex: Samsung Galaxy S9 com 128gb de memória, com caixa, todos os cabos e sem marca de uso.',
                  hintStyle:
                      textFamily(fontSize: 14, color: darkGrey.withOpacity(.7)),
                ),
                onChanged: (val) {
                  // print('description: $val');
                  store.editingAd
                      ? store.adEdit.description = val
                      : store.setAdsDescription(val);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text(
              'Categoria*',
              style: textFamily(
                fontSize: 15,
                color: totalBlack,
              ),
            ),
          ),
          Center(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: () =>
                  Modular.to.pushNamed('/advertisement/choose-category'),
              child: Container(
                height: wXD(52, context),
                width: wXD(342, context),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: primary),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.only(
                    left: wXD(12, context), right: wXD(15, context)),
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.editingAd
                                ? '${store.adEdit.category}        ${store.adEdit.option}'
                                : store.adsCategory == ''
                                    ? 'Selecione uma categoria'
                                    : '${store.adsCategory}        ${store.adsOption}',
                            style: textFamily(
                                fontSize: 14, color: darkGrey.withOpacity(.7)),
                          ),
                          Visibility(
                            visible: store.categoryValidateVisible,
                            child: Text(
                              store.getCategoryValidateText(),
                              style: textFamily(
                                fontSize: 11,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: primary,
                      size: wXD(17, context),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Tipo*',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
          ),
          Center(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: () => store.setSearchType(true),
              child: Container(
                height: wXD(52, context),
                width: wXD(342, context),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: primary),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.only(
                    left: wXD(12, context), right: wXD(15, context)),
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.editingAd
                                ? store.adEdit.type
                                : store.adsType == ''
                                    ? 'Selecione o tipo'
                                    : store.adsType,
                            style: textFamily(
                                fontSize: 14, color: darkGrey.withOpacity(.7)),
                          ),
                          Visibility(
                            visible: store.typeValidateVisible,
                            child: Text(
                              'Selecione um tipo',
                              style: textFamily(
                                fontSize: 11,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Spacer(),
                    Transform.rotate(
                      angle: math.pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: primary,
                        size: wXD(17, context),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Tipo da entrega*',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
          ),
          Center(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: () => Modular.to.pushNamed('/advertisement/delivery-fee'),
              child: Container(
                height: wXD(52, context),
                width: wXD(342, context),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: primary),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.only(
                    left: wXD(12, context), right: wXD(15, context)),
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDeliveryTypeText(
                              editing: store.editingAd,
                              deliveryType: store.deliveryType,
                              deliveryTypeEdit: store.adEdit.deliveryType,
                            ),
                            style: textFamily(
                                fontSize: 14, color: darkGrey.withOpacity(.7)),
                          ),
                          Visibility(
                            visible: store.deliveryTypeValidate,
                            child: Text(
                              'Tipo da entrega é obrigatório',
                              style: textFamily(
                                fontSize: 11,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: primary,
                      size: wXD(17, context),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(20, context)),
            child: Text('Novo/Usado*',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Observer(
                builder: (
                  context,
                ) {
                  return GestureDetector(
                    onTap: () {
                      store.editingAd
                          ? setState(() {
                              store.adEdit.isNew = true;
                            })
                          : store.setAdsIsNew(true);
                      // print('STORE isNew ? ${store.adsIsNew}');
                    },
                    child: Container(
                      height: wXD(32, context),
                      width: wXD(155, context),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: store.editingAd
                            ? store.adEdit.isNew
                                ? primary
                                : white
                            : store.adsIsNew
                                ? primary
                                : white,
                        border: Border.all(
                          color: store.editingAd
                              ? store.adEdit.isNew
                                  ? Colors.transparent
                                  : lightGrey.withOpacity(.8)
                              : store.adsIsNew
                                  ? Colors.transparent
                                  : lightGrey.withOpacity(.8),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            color: Color(0x30000000),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Novo',
                        style: textFamily(
                          color: store.editingAd
                              ? store.adEdit.isNew
                                  ? white
                                  : textTotalBlack
                              : store.adsIsNew
                                  ? white
                                  : textTotalBlack,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Observer(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      store.editingAd
                          ? setState(() {
                              store.adEdit.isNew = false;
                            })
                          : store.setAdsIsNew(false);
                      // print('STORE isNew ? ${store.adsIsNew}');
                    },
                    child: Container(
                      height: wXD(32, context),
                      width: wXD(155, context),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: store.editingAd
                            ? !store.adEdit.isNew
                                ? primary
                                : white
                            : !store.adsIsNew
                                ? primary
                                : white,
                        border: Border.all(
                          color: store.editingAd
                              ? !store.adEdit.isNew
                                  ? Colors.transparent
                                  : lightGrey.withOpacity(.8)
                              : !store.adsIsNew
                                  ? Colors.transparent
                                  : lightGrey.withOpacity(.8),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            color: Color(0x30000000),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Usado',
                        style: textFamily(
                          color: store.editingAd
                              ? !store.adEdit.isNew
                                  ? white
                                  : textTotalBlack
                              : !store.adsIsNew
                                  ? white
                                  : textTotalBlack,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Preço do produto (R\$)',
                style: textFamily(
                  fontSize: 15,
                  color: totalBlack,
                )),
          ),
          Container(
            height: wXD(52, context),
            width: wXD(171, context),
            decoration: BoxDecoration(
              color: white,
              border: Border.all(color: primary),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
            margin: EdgeInsets.only(left: wXD(17, context)),
            child: TextFormField(
              // initialValue: store.editingAd
              //     ? _formatter.format((store.adEdit.sellerPrice * 10).toString())
              //     : null,
              initialValue: 'R\$ ${formatedCurrency(store.adEdit.totalPrice)}',
              inputFormatters: [_formatter],
              keyboardType: TextInputType.number,
              validator: (val) {
                // print('val price: $val');
                if (val!.isEmpty) {
                  return 'Escreva um preço válido';
                }
                return null;
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Digite o seu preço',
              ),
              onChanged: (val) {
                // print('price: ${_formatter.getUnformattedValue()}');
                store.getFinalPrice(_formatter.getUnformattedValue());
              },
            ),
            alignment: Alignment.centerLeft,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text(
              'Taxa de serviço (R\$)',
              style: textFamily(
                fontSize: 15,
                color: totalBlack,
              ),
            ),
          ),
          Observer(builder: (context) {
            return Column(
              children: [
                Container(
                  height: wXD(52, context),
                  width: wXD(171, context),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
                  margin: EdgeInsets.only(left: wXD(17, context)),
                  child: Text(
                    getRateServicePrice(store.rateService),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                // Container(
                //   padding: EdgeInsets.only(left: wXD(17, context)),
                //   child: Text(
                //     'Esse será o valor à ser exibido',
                //     style: textFamily(
                //       fontSize: 11,
                //       color: Colors.red.shade400,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
              ],
            );
          }),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text(
              'Você receberá (R\$)',
              style: textFamily(
                fontSize: 15,
                color: totalBlack,
              ),
            ),
          ),
          Observer(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: wXD(52, context),
                  width: wXD(171, context),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
                  margin: EdgeInsets.only(left: wXD(17, context)),
                  child: Text(
                    getSellerPrice(store.sellerPrice),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  padding: EdgeInsets.only(left: wXD(17, context)),
                  child: Text(
                    'Esse será o valor recebido a cada compra',
                    style: textFamily(
                      fontSize: 11,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      );
    });
  }

  String getRateServicePrice(num value) {
    if (store.editingAd) {
      return 'R\$ ${formatedCurrency(store.adEdit.rateServicePrice)}';
    } else {
      return 'R\$ ${formatedCurrency(store.rateService)}';
    }
  }

  String getSellerPrice(num? value) {
    if (store.editingAd) {
      return 'R\$ ${formatedCurrency(store.adEdit.sellerPrice)}';
    } else {
      return 'R\$ ${formatedCurrency(store.sellerPrice)}';
    }
  }

  String getDeliveryTypeText(
      {required bool editing,
      required String deliveryTypeEdit,
      required String deliveryType}) {
    if (editing && deliveryTypeEdit != '') {
      switch (deliveryTypeEdit) {
        case "moto":
          return "Moto";

        case "car":
          return "Carro";

        case "sedan":
          return "Carro sedan";

        case "utility":
          return "Utilitário";

        default:
          return '';
      }
    } else {
      switch (deliveryType) {
        case "moto":
          return "Moto";

        case "car":
          return "Carro";

        case "sedan":
          return "Carro sedan";

        case "utility":
          return "Utilitário";

        case "":
          return "Selecione um veículo";

        default:
          return '';
      }
    }
  }
}
