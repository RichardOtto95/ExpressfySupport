import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'advertisement_store.g.dart';

class AdvertisementStore = _AdvertisementStoreBase with _$AdvertisementStore;

abstract class _AdvertisementStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  bool addAds = true;
  @observable
  bool delete = false;
  @observable
  bool takePicture = false;
  @observable
  bool searchType = false;
  @observable
  bool deleteImage = false;
  @observable
  bool adsIsNew = true;
  @observable
  bool categoryValidateVisible = false;
  @observable
  bool typeValidateVisible = false;
  @observable
  bool imagesEmpty = false;
  @observable
  bool circularIndicator = false;
  @observable
  bool charging = false;
  @observable
  bool editingAd = false;
  @observable
  bool removingEditingAd = false;
  @observable
  int imageSelected = 0;
  @observable
  int adsActive = 0;
  @observable
  int adsPending = 0;
  @observable
  int adsExpired = 0;
  @observable
  num? sellerPrice;
  @observable
  String adsTitle = '';
  @observable
  String adsDescription = '';
  @observable
  String adsCategory = '';
  @observable
  String adsType = '';
  @observable
  String adsOption = '';
  @observable
  String adsStatusSelected = 'ACTIVE';
  @observable
  String? sellerId;
  @observable
  AdsModel adDelete = AdsModel();
  @observable
  AdsModel adEdit = AdsModel();
  @observable
  List<DocumentSnapshot> types = [];
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  ObservableList<AdsModel> activeAds = <AdsModel>[].asObservable();
  @observable
  ObservableList<AdsModel> pendingAds = <AdsModel>[].asObservable();
  @observable
  ObservableList<AdsModel> expiredAds = <AdsModel>[].asObservable();
  @observable
  String deliveryType = '';
  @observable
  bool deliveryTypeValidate = false;
  @observable
  num totalPrice = 0;
  @observable
  num rateService = 0;
  @observable
  OverlayEntry? redirectOverlay;

  @action
  setAddAds(_addAds) => addAds = _addAds;
  @action
  setdelete(_delete) => delete = _delete;
  @action
  settakePicture(_takePicture) => takePicture = _takePicture;
  @action
  setSearchType(_searchType) => searchType = _searchType;
  @action
  setImageSelected(_imageSelected) => imageSelected = _imageSelected;
  @action
  setDeleteImage(_deleteImage) => deleteImage = _deleteImage;
  @action
  setAdDelete(_adDelete) => adDelete = _adDelete;
  @action
  setEditingAd(_editingAd) => editingAd = _editingAd;
  @action
  setAdEdit(_adEdit) => adEdit = _adEdit;
  @action
  setAdsTitle(_adsTitle) => adsTitle = _adsTitle;
  @action
  setAdsDescription(_adsDescription) => adsDescription = _adsDescription;
  @action
  setAdsCategory(_adsCategory) => adsCategory = _adsCategory;
  @action
  setAdsOption(_adsOption) => adsOption = _adsOption;
  @action
  setAdsType(_adsType) => adsType = _adsType;
  @action
  setAdsIsNew(_adsIsNew) => adsIsNew = _adsIsNew;
  @action
  setAdsPrice(_adsPrice) => sellerPrice = _adsPrice;
  @action
  setAdsStatusSelected(_adsStatusSelected) =>
      adsStatusSelected = _adsStatusSelected;
  @action
  setRemovingEditingAd(_removingEditingAd) =>
      removingEditingAd = _removingEditingAd;

  @action
  Future<void> getFinalPrice(num price) async {
    QuerySnapshot infoQuery =
        await FirebaseFirestore.instance.collection('info').get();
    DocumentSnapshot infoDoc = infoQuery.docs.first;

    // print("rateService: ${price * infoDoc['rate_service']}");

    num _rateService =
        num.parse((price * infoDoc['rate_service']).toStringAsFixed(2));

    // print("sellerPrice: ${price - (price * infoDoc['rate_service'])}");

    num _sellerPrice = num.parse((price - _rateService).toStringAsFixed(2));

    // print('getFinalPrice: $price, $_rateService, $_sellerPrice');
    if (editingAd) {
      adEdit.sellerPrice = _sellerPrice;
      adEdit.rateServicePrice = _rateService;
      adEdit.totalPrice = price;
    } else {
      setAdsPrice(price);
    }

    sellerPrice = _sellerPrice;
    rateService = _rateService;
    totalPrice = price;
  }

  @action
  bool getProgress() => circularIndicator;

  @action
  List<AdsModel> setAdsValues(QuerySnapshot _qs) {
    activeAds.clear();
    pendingAds.clear();
    expiredAds.clear();

    int _adsActive = 0;
    // int _adsPending = 0;
    // int _adsExpired = 0;

    List<AdsModel> _activeAds = [];
    // List<AdsModel> _pendingAds = [];
    // List<AdsModel> _expiredAds = [];

    _qs.docs.forEach((adsDoc) {
      // print(adsDoc.data());
      AdsModel adsModel = AdsModel.fromDoc(adsDoc);

      if (adsModel.status != "DELETED") {
        switch (adsModel.status) {
          case 'ACTIVE':
            _adsActive += 1;
            _activeAds.add(adsModel);
            break;
          case 'PENDING':
            _adsActive += 1;
            _activeAds.add(adsModel);
            // _adsPending += 1;
            // _pendingAds.add(adsModel);
            break;
          // case 'EXPIRED':
          //   _adsExpired += 1;
          //   _expiredAds.add(adsModel);
          //   break;
          default:
        }
      }
    });

    activeAds = _activeAds.asObservable();

    return _activeAds;

    // activeAds = _activeAds.asObservable();
    // pendingAds = _pendingAds.asObservable();
    // expiredAds = _expiredAds.asObservable();

    // adsActive = _adsActive;
    // adsPending = _adsPending;
    // adsExpired = _adsExpired;

    // return false;
  }

  @action
  String getCategoryValidateText() {
    // print('val price: $val');
    if (adsCategory == '' && adsOption != '') {
      // print('Categoria 1');
      return 'Escolha uma categoria';
    }
    if (adsCategory != '' && adsOption == '') {
      // print('Categoria 2');
      return 'Escolha uma opção';
    }
    if (adsCategory == '' && adsOption == '') {
      // print('Categoria 3');
      return 'Escolha uma categoria e uma opção';
    }
    return 'Algo de errado não está certo';
  }

  @action
  callDelete({bool removeDelete = false, AdsModel? ad}) {
    if (removeDelete) {
      setdelete(false);
    } else {
      adDelete = ad!;
      setdelete(true);
    }
  }

  @action
  uploadImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      // print('@@@@@@@@@@@@ images.length: ${images.length}  @@@@@@@@@ ');

      final List<XFile>? pickedFile = await picker.pickMultiImage();
      if (pickedFile != null) {
        int filesLength = pickedFile.length;
        // print(
        //     '################## filesLength: $filesLength // images.length: ${images.length}');
        if ((filesLength + images.length + adEdit.images.length) > 6) {
          Fluttertoast.showToast(msg: 'Somente 6 imagens são permitidas');
          int imagensAMais =
              filesLength + images.length + adEdit.images.length - 6;
          pickedFile.removeRange(
            pickedFile.length - imagensAMais,
            pickedFile.length,
          );
        }
        pickedFile.forEach((xFile) async {
          final File bytes = File(xFile.path);
          images.add(bytes);
        });
        print("$pickedFile + $images + ${adEdit.images}");
        settakePicture(false);
        // print('############# pickedFile: $pickedFile #############');
        // print('################ XFile: ${pickedFile.first}');
      }
    }
  }

  @action
  pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (pickedFile != null) {
        // print('Images.length: ${images.length}');
        if (images.length < 6) {
          images.add(File(pickedFile.path));
        } else {
          Fluttertoast.showToast(msg: 'Somente 6 imagens são permitidas');
        }
      }
    }
  }

  @action
  removeImage() {
    if (removingEditingAd) {
      adEdit.images.removeAt(imageSelected);
    } else {
      images.removeAt(imageSelected);
    }
  }

  @action
  bool getValidate() {
    // print(
    //     'option == "$adsOption" || adsCategory == "$adsCategory" || adsType == "$adsType"');
    if (editingAd) {
      if (adEdit.option == '') {}
      if (adEdit.category == '') {}
      if (adEdit.type == '') {}
    } else if (adsOption == '' ||
        adsCategory == '' ||
        adsType == '' ||
        images.isEmpty ||
        deliveryType.isEmpty) {
      if (adsOption == '' || adsCategory == '') {
        categoryValidateVisible = true;
        // print('categoryValidate: $categoryValidateVisible');
      }
      if (adsType == '') {
        typeValidateVisible = true;
      }
      if (images.isEmpty && adEdit.images.isEmpty) {
        imagesEmpty = true;
      }

      if (deliveryType.isEmpty) {
        deliveryTypeValidate = true;
      }
      return false;
    }
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
    deliveryTypeValidate = false;
    return true;
  }

  @action
  Future<List<String>> getImagesLink(
      {required List<File> imageFiles,
      required String uid,
      required docId}) async {
    List<String> imagesLink = [];
    for (var i = 0; i < imageFiles.length; i++) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/$uid/ads/$docId/image_${i + 1}');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFiles[i]);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageString = await taskSnapshot.ref.getDownloadURL();
      // print("ImageString: $imageString");
      imagesLink.add(imageString);
      // print("imagesLink: $imagesLink");
    }
    return imagesLink;
  }

  @action
  createAds(BuildContext context) async {
    // final User? _user = FirebaseAuth.instance.currentUser;

    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)?.insert(overlayEntry);

    circularIndicator = true;

    // String _uid = _user!.uid;

    // print("_user: $_uid");

    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(sellerId)
        .get();

    String status;
    if (rateService < 50) {
      status = "UNDER-ANALYSIS";
    } else {
      status = "ACTIVE";
    }

    // if (sellerDoc['opening_hours'] != null) {
    AdsModel ads = AdsModel(
      deliveryType: deliveryType,
      title: adsTitle,
      description: adsDescription,
      category: adsCategory,
      option: adsOption,
      type: adsType,
      isNew: adsIsNew,
      // price: adsPrice!,
      sellerPrice: sellerPrice!,
      rateServicePrice: rateService,
      totalPrice: totalPrice,
      paused: false,
      status: status,
      images: [],
      sellerId: sellerId!,
      onlineSeller: sellerDoc['online'],
    );

    HttpsCallableResult<dynamic>? result =
        await cloudFunction(function: "createAds", object: ads.toJson());

    List<String> imagesDowloadLink = await getImagesLink(
        imageFiles: images, uid: sellerId!, docId: result!.data);

    await cloudFunction(function: "updateFields", object: {
      "docId": result.data,
      "fields": {"images": imagesDowloadLink},
      "collection": "ads",
      "subCollectionsOf": [
        {"collection": "sellers", "docId": sellerId!},
      ],
    });

    overlayEntry.remove();

    circularIndicator = false;

    Modular.to.pop();

    // await Modular.to.pushNamed('/advertisement/ads-confirm', arguments: {
    //   'title': adsTitle,
    //   'id': result.data,
    // });

    cleanVars();
    // } else {
    //   overlayEntry.remove();

    //   circularIndicator = false;
    //   redirectOverlay = OverlayEntry(
    //     builder: (context) => RedirectPopup(
    //       height: wXD(165, context),
    //       text:
    //           'Você ainda não tem um horário de funcionamento, deseja adicionar um?',
    //       onConfirm: () async {
    //         redirectOverlay!.remove();
    //         redirectOverlay = null;

    //         Modular.to.pushNamed('/profile/edit-profile');
    //         // await Modular.to.pushNamed("/add-card");
    //       },
    //       onCancel: () {
    //         redirectOverlay!.remove();
    //         redirectOverlay = null;
    //       },
    //     ),
    //   );

    //   Overlay.of(context)?.insert(redirectOverlay!);
    // }
  }

  @action
  editAds(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)?.insert(overlayEntry);

    List<String> imagesDowloadLink = await getImagesLink(
        imageFiles: images, uid: adEdit.sellerId, docId: adEdit.id);

    // print("imagesDownloadLink: $imagesDowloadLink");

    adEdit.images = adEdit.images + imagesDowloadLink;

    // print("adEdit.images: ${adEdit.images}");

    circularIndicator = true;

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adEdit.id)
        .update(adEdit.toJson());

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(adEdit.sellerId)
        .collection('ads')
        .doc(adEdit.id)
        .update(adEdit.toJson());

    overlayEntry.remove();

    circularIndicator = false;
    cleanVars();

    Modular.to.pop();
  }

  @action
  cleanVars() {
    adsDescription = '';
    adsCategory = '';
    adsOption = '';
    adsTitle = '';
    adsType = '';
    deliveryType = '';
    deliveryTypeValidate = false;
    totalPrice = 0;
    rateService = 0;
    adsIsNew = true;
    sellerPrice = null;
    images.clear();
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
    adEdit = AdsModel();
  }

  @action
  pauseAds({
    required String adsId,
    required bool pause,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerId!)
        .collection('ads')
        .doc(adsId)
        .update({'paused': pause});

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsId)
        .update({'paused': pause});

    overlayEntry.remove();
  }

  @action
  highlightAd({
    required String adsId,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsId)
        .update({'highlighted': true});

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerId!)
        .collection('ads')
        .doc(adsId)
        .update({'highlighted': true});

    overlayEntry.remove();

    Fluttertoast.showToast(msg: 'Anúncio destacado com sucesso');
  }

  @action
  deleteAds({
    required BuildContext context,
    required int reason,
    required double grade,
    required String note,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    String _reasonToDelete = '';

    switch (reason) {
      case 1:
        _reasonToDelete = 'Vendi pela scorefy';
        break;
      case 2:
        _reasonToDelete = 'Vendi por outro meio';
        break;
      case 3:
        _reasonToDelete = 'Desisti de vender';
        break;
      case 4:
        _reasonToDelete = 'Outro motivo';
        break;
      case 5:
        _reasonToDelete = 'Ainda não vendi';
        break;
      default:
    }

    await FirebaseFirestore.instance.collection('ads').doc(adDelete.id).update({
      'status': 'DELETED',
      'reason_to_delete': _reasonToDelete,
      'scorefy_grade': grade,
      'scorefy_note': note,
    });

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerId!)
        .collection('ads')
        .doc(adDelete.id)
        .update({
      'status': 'DELETED',
      'reason_to_delete': _reasonToDelete,
      'scorefy_grade': grade,
      'scorefy_note': note,
    });

    overlayEntry.remove();
  }
}
