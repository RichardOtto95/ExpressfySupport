import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_support/app/modules/sellers/sellers_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_support/app/shared/widgets/side_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'profile_data_tile.dart';

class AddEditSeller extends StatefulWidget {
  final bool editing;
  const AddEditSeller({Key? key, this.editing = false}) : super(key: key);

  @override
  _AddEditSellerState createState() => _AddEditSellerState();
}

class _AddEditSellerState extends State<AddEditSeller> {
  final SellersStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();

  FocusNode corporatenameFocus = FocusNode();
  FocusNode storenameFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode referencePointFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode fullnameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode sellerFullnameFocus = FocusNode();
  FocusNode sellerPhoneFocus = FocusNode();

  @override
  void initState() {
    // print("seller: ${store.sellerCreateEdit}");
    store.avatarValidated = false;
    super.initState();
  }

  @override
  void dispose() {
    corporatenameFocus.dispose();
    storenameFocus.dispose();
    categoryFocus.dispose();
    descriptionFocus.dispose();
    referencePointFocus.dispose();
    addressFocus.dispose();
    fullnameFocus.dispose();
    phoneFocus.dispose();
    sellerFullnameFocus.dispose();
    sellerPhoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.cleanVars();
        return true;
      },
      child: Listener(
        onPointerDown: (event) =>
            FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              Observer(
                builder: (context) {
                  if (store.sellerCreateEdit.isEmpty) {
                    return const CenterLoadCircular();
                  }
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: viewPaddingTop(context)),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        offset: const Offset(0, 3),
                                        color: totalBlack.withOpacity(.2))
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(60)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(60)),
                                  child: SizedBox(
                                    height: wXD(338, context),
                                    width: maxWidth(context),
                                    child: store.avatar != null
                                        ? Image.file(
                                            store.avatar!,
                                            height: wXD(338, context),
                                            width: maxWidth(context),
                                            fit: BoxFit.fitWidth,
                                          )
                                        : store.sellerCreateEdit["avatar"] !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl: store
                                                    .sellerCreateEdit["avatar"],
                                                height: wXD(338, context),
                                                width: maxWidth(context),
                                                fit: BoxFit.cover,
                                              )
                                            : ColoredBox(
                                                color: white,
                                                child: Image.asset(
                                                  './assets/img/default_alien.png',
                                                  height: wXD(338, context),
                                                  width: maxWidth(context),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: wXD(20, context),
                                right: wXD(17, context),
                                child: InkWell(
                                  onTap: () async {
                                    File? file = await pickCameraImage();
                                    if (file != null) {
                                      store.avatar = file;
                                    }
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: veryLightGrey,
                                    size: wXD(30, context),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: wXD(60, context),
                                right: wXD(17, context),
                                child: InkWell(
                                  onTap: () async {
                                    File? file = await pickImage();
                                    if (file != null) {
                                      store.avatar = file;
                                    }
                                  },
                                  child: Icon(
                                    Icons.image,
                                    color: veryLightGrey,
                                    size: wXD(30, context),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: store.avatarValidated,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: wXD(24, context),
                                  top: wXD(15, context)),
                              child: Text(
                                "Selecione uma imagem para continuar",
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados da loja',
                              style: textFamily(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Razão social',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['corporate_name'],
                            focusNode: corporatenameFocus,
                            onComplete: () => storenameFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['corporate_name'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Nome da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['store_name'],
                            focusNode: storenameFocus,
                            onComplete: () => categoryFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['store_name'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Categoria da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['store_category'],
                            focusNode: categoryFocus,
                            onComplete: () => descriptionFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['store_category'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Descrição da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['store_description'],
                            focusNode: descriptionFocus,
                            onComplete: () =>
                                referencePointFocus.requestFocus(),
                            onChanged: (txt) => store
                                .sellerCreateEdit['store_description'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Ponto de referência',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['reference_point'],
                            focusNode: referencePointFocus,
                            onComplete: () => addressFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['reference_point'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Endereço',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.sellerCreateEdit['address'],
                            focusNode: addressFocus,
                            onComplete: () => fullnameFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['address'] = txt,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados do proprietário',
                              style: textFamily(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Nome completo',
                            data: store.sellerCreateEdit['username'],
                            hint: 'Fulano Ciclano',
                            focusNode: fullnameFocus,
                            onComplete: () => phoneFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['username'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Número de telefone',
                            hint: '+55 (61) 99999-9999',
                            keyboardType: TextInputType.number,
                            data: phoneMask.maskText(
                                store.sellerCreateEdit['phone'] ?? ''),
                            mask: phoneMask,
                            length: 13,
                            focusNode: phoneFocus,
                            onComplete: () =>
                                sellerFullnameFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['phone'] = txt,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados do vendedor',
                              style: textFamily(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Nome completo',
                            data: store.sellerCreateEdit['seller_username'],
                            hint: 'Fulano Ciclano',
                            focusNode: sellerFullnameFocus,
                            onComplete: () => sellerPhoneFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['seller_username'] = txt,
                            validate: false,
                          ),
                          ProfileDataTile(
                            title: 'Número de telefone',
                            hint: '+55 (61) 99999-9999',
                            keyboardType: TextInputType.number,
                            data: phoneMask.maskText(
                                store.sellerCreateEdit['seller_phone'] ?? ''),
                            mask: phoneMask,
                            length: 11,
                            focusNode: sellerPhoneFocus,
                            onComplete: () => sellerPhoneFocus.unfocus(),
                            onChanged: (txt) =>
                                store.sellerCreateEdit['seller_phone'] = txt,
                            validate: false,
                          ),
                          SizedBox(height: wXD(20, context)),
                          SideButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (kDebugMode) {
                                  print("editing: ${widget.editing}");
                                }
                                if (widget.editing) {
                                  await store.editProfile(context);
                                } else {
                                  await store.saveProfile(context);
                                }
                              } else {
                                showToast("Verifique os campos");
                              }
                            },
                            height: wXD(52, context),
                            width: wXD(142, context),
                            title: 'Salvar',
                          ),
                          SizedBox(height: wXD(20, context)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              DefaultAppBar(
                'Editar perfil',
                onPop: () {
                  store.cleanVars();
                  Modular.to.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
