import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/widgets/emtpy_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../core/models/message_model.dart';
import '../../core/models/time_model.dart';
import '../../shared/color_theme.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/center_load_circular.dart';
import '../../shared/widgets/default_app_bar.dart';
import 'support_store.dart';
import 'widgets/conversation.dart';
import 'widgets/search_messages.dart';

class SupportPage extends StatefulWidget {
  final String title;
  const SupportPage({Key? key, this.title = 'SupportPage'}) : super(key: key);
  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  final SupportStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();

  bool searching = false;
  bool hasFocus = false;
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          mainStore.visibleNav) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !mainStore.visibleNav &&
          !hasFocus) {
        mainStore.setVisibleNav(true);
      }
    });
    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        mainStore.setVisibleNav(false);
        hasFocus = true;
      } else {
        mainStore.setVisibleNav(true);
        hasFocus = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchFocus.dispose();
    store.searchText = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // store.disposeSupport();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("supports")
                      // .where("last_update", isNotEqualTo: "")
                      .orderBy("updated_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      if (kDebugMode) {
                        print(snapshot.error);
                      }
                    }
                    
                    if (!snapshot.hasData) {
                      return const CenterLoadCircular();
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        conversations = snapshot.data!.docs;

                    return Column(
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(50, context)),
                        Stack(
                          children: [
                            Container(
                              width: maxWidth(context),
                              height: wXD(41, context),
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: wXD(29, context)),
                                child: Text(
                                  'Minhas conversas',
                                  style: textFamily(
                                    fontSize: 17,
                                    color: darkGrey,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: wXD(8, context),
                              child: SearchMessages(
                                onChanged: (txt) =>
                                    store.searchSupport(txt, snapshot.data!),
                                focusNode: searchFocus,
                              ),
                            ),
                          ],
                        ),
                        Listener(
                          onPointerDown: (_) {
                            print("listener 1");
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Observer(
                            builder: (context) {
                              if ((store.searchedChats != null ||
                                      store.searchedSupport != null) &&
                                  store.searchText != "") {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (store.searchedChats!.isEmpty &&
                                        store.searchedSupport!.isEmpty)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: wXD(70, context)),
                                          Icon(
                                            Icons.search,
                                            size: wXD(90, context),
                                          ),
                                          SizedBox(
                                            width: wXD(250, context),
                                            child: Text(
                                              "Sem mensagens ou chats relacionados com a sua pesquisa!",
                                              style: textFamily(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (store.searchedChats!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: wXD(10, context),
                                          top: wXD(10, context),
                                        ),
                                        child: Text(
                                          "Conversas",
                                          style: textFamily(fontSize: 17),
                                        ),
                                      ),
                                    ...store.searchedChats!
                                        .map(
                                          (chat) => Conversation(
                                            conversationData: chat.data()!,
                                          ),
                                        )
                                        .toList(),
                                    if (store.searchedSupport!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: wXD(10, context),
                                          top: wXD(10, context),
                                        ),
                                        child: Text(
                                          "Mensagens",
                                          style: textFamily(fontSize: 17),
                                        ),
                                      ),
                                    ...store.searchedSupport!.map(
                                      (messageTitle) => MessageSearched(
                                          messageTitle: messageTitle),
                                    ),
                                  ],
                                );
                              }
                              if (conversations.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: wXD(70, context)),
                                    Icon(
                                      Icons.message_outlined,
                                      size: wXD(90, context),
                                    ),
                                    SizedBox(
                                      width: wXD(250, context),
                                      child: Text(
                                        "Sem conversas!",
                                        style: textFamily(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: conversations
                                    .map(
                                      (conversation) => Conversation(
                                          conversationData:
                                              conversation.data()),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: wXD(70, context))
                      ],
                    );
                  },
                ),
              ),
              const Positioned(
                  top: 0, child: DefaultAppBar('Suporte', noPop: true))
            ],
          ),
          // floatingActionButton: FloatingCircleButton(
          //   onTap: () {},
          //   size: wXD(56, context),
          //   child: Icon(
          //     Icons.add,
          //     size: wXD(30, context),
          //     color: primary,
          //   ),
          // ),
        ),
      ),
    );
  }
}

class MessageSearched extends StatelessWidget {
  final SearchMessage messageTitle;
  const MessageSearched({Key? key, required this.messageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("receiverId: ${messageTitle.receiverId}");
    // print("receiverCollection: ${messageTitle.receiverCollection}");
    // print("messageId: ${messageTitle.message.id}");
    return InkWell(
      onTap: () => Modular.to.pushNamed('/chat', arguments: {
        "receiverId": messageTitle.receiverId,
        "receiverCollection": messageTitle.receiverCollection.toLowerCase(),
        "messageId": messageTitle.message.id,
      }),
      child: Container(
        width: maxWidth(context),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(8, context),
          vertical: wXD(10, context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  messageTitle.title,
                  style: textFamily(fontSize: 15),
                ),
                Text(
                  Time(messageTitle.message.createdAt!.toDate()).chatTime(),
                  style: textFamily(fontSize: 11),
                )
              ],
            ),
            SizedBox(height: wXD(3, context)),
            Text(
              messageTitle.message.text!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textFamily(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
