import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  String? storeName;
  String? corporateName;
  String? cnpj;
  String? avatar;
  String? fullname;
  String? username;
  Timestamp? birthday;
  String? cpf;
  String? rg;
  String? issuingAgency;
  String? gender;
  String? id;
  String? phone;
  String? status;
  String? bank;
  String? agency;
  String? operation;
  String? country;
  String? storeCategory;
  String? storeDescription;
  String? returnPolicies;
  String? warranty;
  String? paymentMethod;
  String? mainAddress;
  Timestamp? createdAt;
  int newQuestions;
  int newRatings;
  int newMessages;
  int newTransactions;
  int newSupportMessages;
  List? tokenId;
  bool? connected;
  bool? notificationEnabled;
  bool? savingsAccount;
  bool? linkedToCnpj;
  bool? online;
  String? openingHours;

  Seller({
    this.storeCategory,
    this.storeDescription,
    this.returnPolicies,
    this.warranty,
    this.paymentMethod,
    this.storeName,
    this.corporateName,
    this.cnpj,
    this.createdAt,
    this.avatar,
    this.fullname,
    this.username,
    this.birthday,
    this.cpf,
    this.rg,
    this.issuingAgency,
    this.gender,
    this.id,
    this.phone,
    this.status,
    this.tokenId,
    this.connected,
    this.bank,
    this.agency,
    this.operation,
    this.savingsAccount,
    this.notificationEnabled,
    this.linkedToCnpj,
    this.country,
    this.newQuestions = 0,
    this.newRatings = 0,
    this.newTransactions = 0,
    this.newMessages = 0,
    this.newSupportMessages = 0,
    this.mainAddress,
    this.online,
    this.openingHours,
  });

  factory Seller.fromDoc(DocumentSnapshot doc) {
    return Seller(
      storeName: doc['store_name'],
      corporateName: doc['corporate_name'],
      cnpj: doc['cnpj'],
      createdAt: doc['created_at'],
      avatar: doc['avatar'],
      fullname: doc['fullname'],
      username: doc['username'],
      birthday: doc['birthday'],
      cpf: doc['cpf'],
      rg: doc['rg'],
      issuingAgency: doc['issuing_agency'],
      gender: doc['gender'],
      id: doc['id'],
      phone: doc['phone'],
      status: doc['status'],
      // newNotifications: doc['new_notifications'],
      tokenId: doc['token_id'],
      connected: doc['connected'],
      bank: doc['bank'],
      agency: doc['agency'],
      operation: doc['operation'],
      savingsAccount: doc['savings_account'],
      linkedToCnpj: doc['linked_to_cnpj'],
      country: doc['country'],
      notificationEnabled: doc['notification_enabled'],
      paymentMethod: doc['payment_method'],
      returnPolicies: doc['return_policies'],
      storeCategory: doc['store_category'],
      storeDescription: doc['store_description'],
      warranty: doc['warranty'],
      newQuestions: doc['new_questions'],
      newRatings: doc['new_ratings'],
      newTransactions: doc['new_transactions'],
      newMessages: doc['new_messages'],
      newSupportMessages: doc['new_support_messages'],
      mainAddress: doc['main_address'],
      online: doc['online'],
      openingHours: doc['opening_hours'],
    );
  }

  Map<String, dynamic> toJson({Seller? model}) => model == null
      ? {
          'store_name': storeName,
          'corporate_name': corporateName,
          'cnpj': cnpj,
          'created_at': createdAt,
          'avatar': avatar,
          'fullname': fullname,
          'username': username,
          'birthday': birthday,
          'cpf': cpf,
          'rg': rg,
          'issuing_agency': issuingAgency,
          'gender': gender,
          'id': id,
          'phone': phone,
          'status': status,
          // 'new_notifications': newNotifications,
          'token_id': tokenId,
          'connected': connected,
          'bank': bank,
          'agency': agency,
          'operation': operation,
          'savings_account': savingsAccount,
          'linked_to_cnpj': linkedToCnpj,
          'country': country,
          'notification_enabled': notificationEnabled,
          'payment_method': paymentMethod,
          'return_policies': returnPolicies,
          'store_category': storeCategory,
          'store_description': storeDescription,
          'warranty': warranty,
          'new_questions': newQuestions,
          'new_ratings': newRatings,
          'new_transactions': newTransactions,
          'new_messages': newMessages,
          'new_support_messages': newSupportMessages,
          'main_address': mainAddress,
          'online': online,
          'opening_hours': openingHours,
        }
      : {
          'store_name': model.storeName,
          'corporate_name': model.corporateName,
          'cnpj': model.cnpj,
          'created_at': model.createdAt,
          'avatar': model.avatar,
          'fullname': model.fullname,
          'username': model.username,
          'birthday': model.birthday,
          'cpf': model.cpf,
          'rg': model.rg,
          'issuing_agency': model.issuingAgency,
          'gender': model.gender,
          'id': model.id,
          'phone': model.phone,
          'status': model.status,
          // 'new_notifications': model.newNotifications,
          'token_id': model.tokenId,
          'connected': model.connected,
          'bank': model.bank,
          'agency': model.agency,
          'operation': model.operation,
          'savings_account': model.savingsAccount,
          'linked_to_cnpj': model.linkedToCnpj,
          'country': model.country,
          'notification_enabled': model.notificationEnabled,
          'payment_method': model.paymentMethod,
          'return_policies': model.returnPolicies,
          'store_category': model.storeCategory,
          'store_description': model.storeDescription,
          'warranty': model.warranty,
          'new_questions': model.newQuestions,
          'new_ratings': model.newRatings,
          'new_transactions': model.newTransactions,
          'new_messages': model.newMessages,
          'new_support_messages': model.newSupportMessages,
          'main_address': model.mainAddress,
          'online': model.online,
          'opening_hours': model.openingHours,
        };

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSelStream() =>
      FirebaseFirestore.instance.collection("sellers").doc(id).snapshots();
}
