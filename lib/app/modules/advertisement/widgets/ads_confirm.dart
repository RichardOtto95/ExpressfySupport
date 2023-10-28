import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class AdsConfirm extends StatelessWidget {
  final Map group;
  final MainStore mainStore = Modular.get();

  AdsConfirm({Key? key, required this.group}) : super(key: key);
  final AdvertisementStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    OverlayEntry? confirmPauseOverlay;
    return WillPopScope(
      onWillPop: () async {
        // print('onWillPop ads-confirm: ${Modular.to.path}');

        Modular.to.popUntil(ModalRoute.withName('/advertisement/'));

        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: wXD(115, context)),
                  Text(
                    'Seu anúncio estará ativo em\nbreve!',
                    textAlign: TextAlign.center,
                    style: textFamily(fontSize: 20, color: totalBlack),
                  ),
                  Container(
                    height: wXD(290, context),
                    width: wXD(342, context),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border: Border.all(color: Color(0xfff1f1f1)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          color: Color(0x30000000),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: wXD(16, context),
                        vertical: wXD(18, context)),
                    padding: EdgeInsets.fromLTRB(
                      wXD(7, context),
                      wXD(23, context),
                      wXD(7, context),
                      wXD(16, context),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: wXD(20, context),
                            right: wXD(20, context),
                            bottom: wXD(14, context),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: darkGrey.withOpacity(.2)))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Venda mais rápido seu anúncio:',
                                style: textFamily(
                                  fontSize: 16,
                                  color: totalBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                // '"Samsung Galaxy A51+"',
                                group['title'],
                                style: textFamily(
                                  fontSize: 16,
                                  color: totalBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: wXD(33, context)),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: textFamily(
                                        fontSize: 28, color: darkGrey),
                                    children: [
                                      TextSpan(text: 'R\$'),
                                      TextSpan(
                                          style: textFamily(
                                            color: primary,
                                            fontSize: 28,
                                          ),
                                          text: '*30,00')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: wXD(14, context)),
                              Center(
                                child: Material(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  color: primary,
                                  elevation: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      confirmPauseOverlay = OverlayEntry(
                                        builder: (context) => ConfirmPopup(
                                          height: wXD(140, context),
                                          text:
                                              'Tem certeza que deseja destacar esta publicação?',
                                          onConfirm: () async {
                                            await store.highlightAd(
                                                adsId: group['id'],
                                                context: context);
                                            confirmPauseOverlay!.remove();
                                            confirmPauseOverlay = null;
                                            Modular.to.pop();
                                            Modular.to.pop();
                                          },
                                          onCancel: () {
                                            confirmPauseOverlay!.remove();
                                            confirmPauseOverlay = null;
                                          },
                                        ),
                                      );
                                      Overlay.of(context)!
                                          .insert(confirmPauseOverlay!);
                                      // store.highlightAd(
                                      //     adsId: group['id'], context: context);
                                    },
                                    child: Container(
                                      height: wXD(41, context),
                                      width: wXD(217, context),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Destacar agora',
                                        style: textFamily(
                                          fontSize: 16,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: wXD(6, context), top: wXD(14, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Anúncio ficará disponível no topo',
                                style: textFamily(fontSize: 12),
                              ),
                              SizedBox(height: wXD(2, context)),
                              Text(
                                'Anúncio ficará 7 dias com o selo "destaque"',
                                style: textFamily(fontSize: 12),
                              ),
                              SizedBox(height: wXD(2, context)),
                              Text(
                                'Lorem Impsum Lorem Ipsum Lorem Ipsum',
                                style: textFamily(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Modular.to.popUntil(ModalRoute.withName('/main'));
                      Modular.to
                          .popUntil(ModalRoute.withName('/advertisement/'));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: wXD(15, context)),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: textFamily(
                                fontSize: 14,
                                color: primary,
                              ),
                              text: 'Clique aqui ',
                            ),
                            TextSpan(
                              style: textFamily(
                                fontSize: 14,
                                color: textTotalBlack,
                              ),
                              text: 'para continuar sem destaque',
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            DefaultAppBar(
              'Anúncio inserido',
              onPop: () {
                Modular.to.popUntil(ModalRoute.withName('/advertisement/'));
              },
            )
          ],
        ),
      ),
    );
  }
}
