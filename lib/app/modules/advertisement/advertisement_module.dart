import 'package:delivery_support/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_support/app/modules/advertisement/widgets/ads_confirm.dart';
import 'package:delivery_support/app/modules/advertisement/widgets/choose_category.dart';
import 'package:delivery_support/app/modules/advertisement/widgets/create_ads.dart';
// ignore: unused_import, implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'advertisement_page.dart';
import 'widgets/category.dart';
import 'widgets/delivery_fee.dart';

class AdvertisementModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AdvertisementStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AdvertisementPage(sellerId: args.data)),
    ChildRoute('/create-ads', child: (_, args) => CreateAds()),
    ChildRoute('/ads-confirm',
        child: (_, args) => AdsConfirm(group: args.data)),
    ChildRoute('/choose-category', child: (_, args) => ChooseCategory()),
    ChildRoute('/delivery-fee', child: (_, args) => DeliveryFee()),
    ChildRoute('/category',
        child: (_, args) => Category(
              categoryId: args.data,
            )),
  ];
}
