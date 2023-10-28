import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_support/app/shared/widgets/congratulations_popup.dart';
import 'package:delivery_support/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../advertisement_store.dart';

class DeleteAds extends StatefulWidget {
  final ScrollController scrollController;

  const DeleteAds({Key? key, required this.scrollController}) : super(key: key);
  @override
  _DeleteAdsState createState() => _DeleteAdsState();
}

class _DeleteAdsState extends State<DeleteAds> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final TextEditingController textController = TextEditingController();

  ScrollPhysics scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  FocusNode focusNode = FocusNode();

  late OverlayEntry overlayEntry;
  OverlayEntry? overlayDeleteAds;

  int reasonToDelete = 0;
  double grade = .5;
  String note = '';

  double height = 0;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      // print("offSet: ${wXD(widget.scrollController.offset, context)}");
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          height = wXD(250, context);
        });
        // print('height: $height');
        Future.delayed(
            const Duration(milliseconds: 550),
            () => widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ));
      } else {
        setState(() {
          height = 0;
        });
        // print('height: $height');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    widget.scrollController.removeListener(() {});
    super.dispose();
  }

  OverlayEntry getoverlay() {
    return OverlayEntry(
      builder: (context) {
        return CongratulationsPopup(
          text: 'Parabéns',
          subText: 'Você despegou!\nObrigado por anunciar com a gente',
          onNewAd: () async {
            overlayEntry.remove();
            overlayDeleteAds!.remove();
            overlayDeleteAds = null;
            store.callDelete(removeDelete: true);
            mainStore.setVisibleNav(true);
            mainStore.paginateEnable = true;
            await Modular.to.pushNamed('/advertisement/create-ads');
          },
          onBack: () {
            overlayEntry.remove();
            overlayDeleteAds!.remove();
            overlayDeleteAds = null;
            mainStore.setVisibleNav(true);
            mainStore.paginateEnable = true;
            store.callDelete(removeDelete: true);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      height: maxHeight(context),
      child: SingleChildScrollView(
        physics: scrollPhysics,
        controller: widget.scrollController,
        child: Listener(
          onPointerDown: (a) {
            focusNode.unfocus();
          },
          child: Column(
            children: [
              GestureDetector(
                onTap: () => store.callDelete(removeDelete: true),
                child: Container(
                  height: wXD(120, context),
                  width: maxWidth(context),
                  color: Colors.transparent,
                ),
              ),
              Container(
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Observer(builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: wXD(46, context),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Text('Excluir anúncio',
                            style: textFamily(
                              fontSize: 17,
                              color: white,
                            )),
                        alignment: Alignment.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(14, context),
                          bottom: wXD(11, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: darkGrey.withOpacity(.2)))),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Excluir anúncio',
                              style: textFamily(
                                fontSize: 14,
                                color: totalBlack.withOpacity(.7),
                              ),
                            ),
                            Text(
                              'Anúncio: ${store.adDelete.title}',
                              style: textFamily(
                                fontSize: 12,
                                color: totalBlack.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(18, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: darkGrey.withOpacity(.2)),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Qual o motivo para excluir esse anúncio?',
                              style:
                                  textFamily(fontSize: 12, color: totalBlack),
                            ),
                            SizedBox(height: wXD(25, context)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 1),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F),
                                          width: wXD(2, context)),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 1
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Vendi pela Scorefy',
                                  style: textFamily(
                                    fontSize: 12,
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 2),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 2
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Vendi por outro meio',
                                  style: textFamily(
                                    fontSize: 12,
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 3),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 3
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Desisti de vender',
                                  style: textFamily(
                                    fontSize: 12,
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 4),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 4
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Outro motivo',
                                  style: textFamily(
                                    fontSize: 12,
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => reasonToDelete = 5),
                                  child: Container(
                                    height: wXD(19, context),
                                    width: wXD(19, context),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0XFF9F9F9F), width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: wXD(12, context),
                                      bottom: wXD(13, context),
                                    ),
                                    alignment: Alignment.center,
                                    child: reasonToDelete == 5
                                        ? Container(
                                            height: wXD(11, context),
                                            width: wXD(11, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Text(
                                  'Ainda não vendi',
                                  style: textFamily(
                                    fontSize: 12,
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: wXD(12, context),
                          top: wXD(18, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: darkGrey.withOpacity(.2)),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Você recomendaria a Scorefy?',
                              style:
                                  textFamily(fontSize: 12, color: totalBlack),
                            ),
                            SizedBox(height: wXD(25, context)),
                            Center(
                              child: Container(
                                width: wXD(310, context),
                                child: Slider(
                                  onChanged: (a) => setState(() {
                                    grade = a;
                                  }),
                                  value: grade,
                                  activeColor: primary,
                                  inactiveColor: Color(0xffbdbdbd),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: wXD(17, context)),
                                Text(
                                  'Não',
                                  style: textFamily(
                                      fontSize: 12, color: totalBlack),
                                ),
                                Spacer(),
                                Text(
                                  'Sim',
                                  style: textFamily(
                                      fontSize: 12, color: totalBlack),
                                ),
                                SizedBox(width: wXD(17, context)),
                              ],
                            ),
                            SizedBox(height: wXD(17, context)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: wXD(12, context),
                            top: wXD(24, context),
                            bottom: wXD(11, context)),
                        child: Text(
                          'Você recomendaria a Scorefy?',
                          style: textFamily(fontSize: 12, color: totalBlack),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: wXD(52, context),
                          width: wXD(342, context),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(15, context)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            focusNode: focusNode,
                            controller: textController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Comentário'),
                            onChanged: (val) {
                              note = val;
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: wXD(39, context),
                          bottom: wXD(34, context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SideButton(
                              onTap: () async {
                                store.callDelete(removeDelete: true);
                                mainStore.paginateEnable = true;
                                await Future.delayed(Duration(seconds: 1),
                                    () => mainStore.setVisibleNav(true));

                                cleanVars();
                              },
                              isWhite: true,
                              title: 'Cancelar',
                              height: wXD(52, context),
                              width: wXD(142, context),
                            ),
                            SideButton(
                              onTap: () {
                                overlayDeleteAds = OverlayEntry(
                                  builder: (context) => ConfirmPopup(
                                    height: wXD(140, context),
                                    text:
                                        'Tem certeza que deseja excluir esta publicação?',
                                    onConfirm: () async {
                                      if (reasonToDelete == 0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Selecione um motivo para a exclusão');
                                        overlayDeleteAds!.remove();
                                      } else {
                                        await store.deleteAds(
                                          context: context,
                                          reason: reasonToDelete,
                                          grade: grade,
                                          note: note,
                                        );
                                        overlayEntry = getoverlay();
                                        Overlay.of(context)
                                            ?.insert(overlayEntry);
                                        cleanVars();
                                      }
                                    },
                                    onCancel: () {
                                      overlayDeleteAds!.remove();
                                      overlayDeleteAds = null;
                                    },
                                  ),
                                );
                                Overlay.of(context)!.insert(overlayDeleteAds!);
                              },
                              title: 'Enviar',
                              height: wXD(52, context),
                              width: wXD(142, context),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: height,
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cleanVars() {
    reasonToDelete = 0;
    grade = .5;
    note = '';
    store.setAdDelete(AdsModel());
    textController.clear();
    widget.scrollController
        .animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
    focusNode.unfocus();
  }
}
