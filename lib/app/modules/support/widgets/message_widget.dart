import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/message_model.dart';
import '../../../core/models/time_model.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class MessageWidget extends StatelessWidget {
  final Message messageData;
  final bool showUserData;
  final bool isAuthor;
  final bool messageBold;
  final String? rightAvatar;
  final String rightName;
  final String? leftAvatar;
  final String leftName;

  const MessageWidget({
    Key? key,
    required this.messageData,
    required this.showUserData,
    required this.isAuthor,
    required this.rightName,
    required this.leftName,
    required this.messageBold,
    this.rightAvatar,
    this.leftAvatar,
  }) : super(key: key);

  @override
  Widget build(context) {
    // print("leftavatar: $leftAvatar");
    return Container(
      width: maxWidth(context),
      // padding: EdgeInsets.only(top: wXD(18, context)),
      alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showUserData)
            Row(
              mainAxisAlignment:
                  isAuthor ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                SizedBox(width: wXD(23, context)),
                isAuthor
                    ? Padding(
                        padding: EdgeInsets.only(top: wXD(15, context)),
                        child: Text(
                          rightName,
                          style: textFamily(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: totalBlack,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(2),
                        margin: EdgeInsets.only(
                            right: wXD(16, context), top: wXD(15, context)),
                        decoration: const BoxDecoration(
                          color: Color(0xff817889),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: leftAvatar == null
                              ? Image.asset(
                                  './assets/img/default_alien.png',
                                  fit: BoxFit.cover,
                                  height: wXD(45, context),
                                  width: wXD(45, context),
                                )
                              : CachedNetworkImage(
                                  imageUrl: leftAvatar!.toString(),
                                  fit: BoxFit.cover,
                                  height: wXD(45, context),
                                  width: wXD(45, context),
                                ),
                        ),
                      ),
                isAuthor
                    ? Container(
                        padding: const EdgeInsets.all(2),
                        margin: EdgeInsets.only(
                            left: wXD(16, context), top: wXD(15, context)),
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            shape: BoxShape.circle,
                            border: Border.all(color: totalBlack, width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: rightAvatar == null
                              ? Image.asset(
                                  './assets/img/default_alien.png',
                                  fit: BoxFit.cover,
                                  height: wXD(45, context),
                                  width: wXD(45, context),
                                )
                              : CachedNetworkImage(
                                  imageUrl: rightAvatar.toString(),
                                  fit: BoxFit.cover,
                                  height: wXD(45, context),
                                  width: wXD(45, context),
                                ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: wXD(15, context)),
                        child: Text(
                          leftName,
                          style: textFamily(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: totalBlack,
                          ),
                        ),
                      ),
                SizedBox(width: wXD(23, context)),
              ],
            ),
          messageData.fileType != null &&
                  messageData.fileType!.startsWith("image/")
              ? Container(
                  padding: EdgeInsets.all(wXD(7, context)),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(17)),
                    color: isAuthor ? totalBlack : rose,
                  ),
                  margin: EdgeInsets.only(
                    top: wXD(8, context),
                    right: wXD(10, context),
                    left: wXD(10, context),
                  ),
                  height: wXD(280, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: wXD(250, context),
                        constraints: BoxConstraints(
                            minWidth: wXD(150, context),
                            maxWidth: wXD(250, context)),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17)),
                          child: Hero(
                            tag: "dash",
                            child: CachedNetworkImage(
                              imageUrl: messageData.file!,
                              fit: BoxFit.fitHeight,
                              progressIndicatorBuilder: (context, _, a) =>
                                  const Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(3, context)),
                      Text(
                        messageData.createdAt != null
                            ? Time(messageData.createdAt!.toDate()).hour()
                            : "",
                        textAlign: isAuthor ? TextAlign.right : TextAlign.left,
                        style: textFamily(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: isAuthor ? white : totalBlack,
                        ),
                      ),
                    ],
                  ),
                )
              // Container(
              //     padding: EdgeInsets.all(wXD(7, context)),
              //     margin: EdgeInsets.only(
              //       top: wXD(8, context),
              //       right: wXD(10, context),
              //       left: wXD(10, context),
              //       // left: isAuthor ? wXD(100, context) : wXD(10, context),
              //       // right: isAuthor ? wXD(10, context) : wXD(100, context),
              //     ),
              //     height: wXD(210, context),
              //     width: wXD(150, context),
              //     decoration: BoxDecoration(
              //       borderRadius: const BorderRadius.all(Radius.circular(17)),
              //       color: isAuthor ? totalBlack : rose,
              //     ),
              //     // alignment:
              //     //     isAuthor ? Alignment.centerRight : Alignment.centerLeft,
              //     alignment: Alignment.center,
              //     child: Column(
              //       crossAxisAlignment: isAuthor
              //           ? CrossAxisAlignment.end
              //           : CrossAxisAlignment.start,
              //       children: [
              //         ClipRRect(
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(17)),
              //           child: CachedNetworkImage(
              //             imageUrl: messageData.file!,
              //             progressIndicatorBuilder: (context, _, a) =>
              //                 const CircularProgressIndicator(
              //               valueColor: AlwaysStoppedAnimation(primary),
              //             ),
              //             height: wXD(180, context),
              //             fit: BoxFit.fitWidth,
              //           ),
              //         ),
              //         SizedBox(height: wXD(3, context)),
              //         Text(
              //           messageData.createdAt != null
              //               ? Time(messageData.createdAt!.toDate()).hour()
              //               : "",
              //           textAlign: isAuthor ? TextAlign.right : TextAlign.left,
              //           style: textFamily(
              //             fontSize: 11,
              //             fontWeight: FontWeight.w400,
              //             color: isAuthor ? white : totalBlack,
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              : Container(
                  padding: EdgeInsets.
                      // symmetric(
                      //     horizontal: wXD(20, context), vertical: wXD(16, context)),
                      fromLTRB(
                    wXD(isAuthor ? 30 : 23, context),
                    wXD(16, context),
                    wXD(isAuthor ? 23 : 30, context),
                    wXD(5, context),
                  ),
                  margin: EdgeInsets.only(
                    left: isAuthor ? wXD(36, context) : 0,
                    right: isAuthor ? 0 : wXD(36, context),
                    top: wXD(8, context),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(isAuthor ? 50 : 0),
                      right: Radius.circular(isAuthor ? 0 : 50),
                    ),
                    color: isAuthor ? totalBlack : const Color(0xffFFDECE),
                  ),
                  child: Column(
                    crossAxisAlignment: isAuthor
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageData.text!,
                        textAlign: TextAlign.left,
                        style: textFamily(
                          fontSize: 14,
                          fontWeight:
                              messageBold ? FontWeight.bold : FontWeight.w400,
                          color: isAuthor ? white : totalBlack,
                        ),
                      ),
                      SizedBox(height: wXD(3, context)),
                      Text(
                        messageData.createdAt != null
                            ? Time(messageData.createdAt!.toDate()).hour()
                            : "",
                        textAlign: isAuthor ? TextAlign.right : TextAlign.left,
                        style: textFamily(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: isAuthor ? white : totalBlack,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
