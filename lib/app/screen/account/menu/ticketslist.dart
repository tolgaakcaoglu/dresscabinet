import 'dart:math';

import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/functions/userfunc.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/ticketmodal.dart';
import 'package:dresscabinet/app/screen/account/menu/ticket/ticketdetail.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class TicketList extends StatefulWidget {
  final Client client;
  final Function update;
  const TicketList({Key key, @required this.client, @required this.update})
      : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  List<Ticket> tickets;

  String subjectController = '';
  String captionController = '';
  bool viewNew = false;
  List<DropdownMenuItem> items;
  Map selectedSubject;
  List subjects;
  List statuses;

  @override
  void initState() {
    super.initState();

    _getTicketSubjects();
    _getTicketStatuses();

    setState(() => tickets = widget.client.tickets);
  }

  _getTicketSubjects() async {
    List list = await JsonFunctions.getTicketSubjects();
    if (mounted) {
      setState(() {
        subjects = list;
        items = _subjectList();
      });
    }
  }

  _getTicketStatuses() async {
    List list = await JsonFunctions.getTicketStatuses();
    if (mounted) {
      setState(() {
        statuses = list;
      });
    }
  }

  _subjectList() {
    List<DropdownMenuItem> list = [];

    for (var item in subjects) {
      list.add(DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(item["konu"]),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('DESTEK')),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: isDark ? Colors.blueGrey : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            setState(() {
              viewNew = !viewNew;
            });
          },
          label: Text(viewNew ? 'Talepten Vazgeç' : 'Talep Oluştur',
              style: const TextStyle(letterSpacing: 0.8)),
        ),
        body: tickets == null
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      if (viewNew) _newArea(isDark, context),
                      tickets.isEmpty
                          ? _nullTicket(context, isDark)
                          : ListView(
                              primary: false,
                              shrinkWrap: true,
                              children: tickets.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListTile(
                                    horizontalTitleGap: 8.0,
                                    tileColor:
                                        isDark ? Colors.white10 : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    leading: Container(
                                      width: 38.0,
                                      height: 38.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: e.statusId == 1
                                              ? Colors.amber
                                              : e.statusId == 2
                                                  ? Colors.green
                                                  : Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                      child: Center(
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            '#${e.statusId.toString()} ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.0,
                                              color: e.statusId == 3 && isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      e.title,
                                      style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      '${ConstUtils.getDate(e.created)} ${e.created.year} tarihinde oluşturuldu.',
                                    ),
                                    onTap: () {
                                      Navigate.next(context,
                                          ClientTicketDetail(ticket: e));
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  SizedBox _nullTicket(BuildContext context, bool isDark) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Iconify(Ri.emotion_happy_fill,
                color: isDark ? Colors.white54 : Colors.black54),
            const SizedBox(height: 16.0),
            Text(
              'Destek talebi oluşturmadınız.',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Padding _newArea(bool isDark, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: isDark ? Colors.white10 : Colors.white,
              ),
              child: DropdownButton(
                isExpanded: true,
                borderRadius: BorderRadius.circular(8.0),
                dropdownColor: isDark ? Colors.black87 : Colors.white,
                hint: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Konu seçin'),
                ),
                value: selectedSubject,
                items: items ?? [],
                onChanged: (v) {
                  setState(() {
                    selectedSubject = v;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          ConstWidgets.textField(
            isDark,
            onChang: (v) {
              setState(() {
                subjectController = v;
              });
            },
            hint: '123 numaralı sipariş',
            label: 'Başlık',
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              minLines: 5,
              maxLines: 10,
              onChanged: (v) {
                setState(() {
                  captionController = v;
                });
              },
              style: const TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: CupertinoButton(
              color: isDark ? Colors.green : Colors.black,
              onPressed: tappedNew,
              child: const Text('Talep Oluştur'),
            ),
          ),
        ],
      ),
    );
  }

  void tappedNew() async {
    if (selectedSubject != null &&
        subjectController.trim().isNotEmpty &&
        captionController.trim().isNotEmpty) {
      dynamic body = await UserFunc.addTicket(
          widget.client.id,
          selectedSubject["id"],
          subjectController.trim(),
          captionController.trim());
      if (body == "1") {
        widget.update();

        setState(() {
          viewNew = false;
          tickets.add(Ticket(
            clientId: widget.client.id,
            created: DateTime.now(),
            id: Random().nextInt(999),
            messages: [
              TicketMessage(
                created: DateTime.now(),
                message: captionController.trim(),
              )
            ],
            statusId: 1,
            subjectId: int.parse(selectedSubject["id"]),
            success: 1,
            title: subjectController.trim(),
          ));
          subjectController = '';
          captionController = '';
        });

        Fluttertoast.showToast(msg: 'Talebiniz oluşturuldu');
      } else {
        Fluttertoast.showToast(msg: body);
      }
    }
  }
}
