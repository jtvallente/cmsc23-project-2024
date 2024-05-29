import 'package:flutter/material.dart';

class StreamListTile extends StatefulWidget {
  final Color color;
  final Widget leading;
  final Widget title;
  final Widget trailing;
  final Widget modal;

  const StreamListTile(
      {required this.color,
      required this.modal,
      required this.leading,
      required this.title,
      required this.trailing,
      super.key});

  @override
  State<StreamListTile> createState() => _StreamListTileState();
}

class _StreamListTileState extends State<StreamListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      surfaceTintColor: widget.color,
      child: ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(height: 500, child: widget.modal

                      // child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Text(organizations[index].name),
                      //         Text(organizations[index].description),
                      //         organizations[index]
                      //                 .proofOfLegitimacyBase64
                      //                 .isNotEmpty
                      //             ? SingleChildScrollView(
                      //                 child: ListView.builder(
                      //                 shrinkWrap: true,
                      //                 itemCount: organizations.length,
                      //                 itemBuilder: (context, i) {
                      //                   return Card(
                      //                     child: ListTile(
                      //                         leading: Icon(Icons.file_copy),
                      //                         title: Text(
                      //                             "Proof of Legitimacy ${index + 1}"),
                      //                         onTap: () => openFileFromBase64String(
                      //                             organizations[index]
                      //                                     .proofOfLegitimacyBase64[
                      //                                 i])),
                      //                   );
                      //                 },
                      //               ))
                      //             : Text("No proof of legitimacy uploaded"),
                      //       ],
                      //     ),
                      //     PrimaryButton(
                      //         label: "Approve",
                      //         onTap: () {
                      //           // Update the user's isApproved attribute to true
                      //           context
                      //               .read<FirebaseAdminProvider>()
                      //               .approveUser(organizations[index].userId);
                      //           Navigator.pop(context);
                      //         },
                      //         gradient: ProjectColors().greenPrimaryGradient,
                      //         fillWidth: true)
                      //   ],
                      // ),
                      ),
                ),
              ),
            );
          },
          title: widget.title,
          leading: widget.leading,
          trailing: widget.trailing),
    );
  }
}
