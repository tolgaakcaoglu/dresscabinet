import 'package:dresscabinet/app/functions/constfunc.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/ticketmodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientTicketDetail extends StatefulWidget {
  final Ticket ticket;
  const ClientTicketDetail({Key key, @required this.ticket}) : super(key: key);

  @override
  State<ClientTicketDetail> createState() => _ClientTicketDetailState();
}

class _ClientTicketDetailState extends State<ClientTicketDetail> {
  Map subject;
  Map status;

  _getTicketSubjects() async {
    List list = await JsonFunctions.getTicketSubjects();
    Map sub;
    if (mounted) {
      for (var item in list) {
        if (widget.ticket.subjectId == int.parse(item["id"])) {
          sub = item;
        }
      }

      setState(() {
        subject = sub;
      });
    }
  }

  _getTicketStatuses() async {
    List list = await JsonFunctions.getTicketStatuses();
    Map stat;
    if (mounted) {
      for (var item in list) {
        if (widget.ticket.statusId == int.parse(item["id"])) {
          stat = item;
        }
      }

      setState(() {
        status = stat;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTicketStatuses();
    _getTicketSubjects();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Talep Detayı')),
      body: subject == null || status == null
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    defaultContainer(
                      context,
                      isDark,
                      Opacity(
                        opacity: 0.7,
                        child: Text('Talep Durumu: ${status["durum"]}'),
                      ),
                    ),
                    defaultContainer(
                      context,
                      isDark,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Başlık: ${widget.ticket.title.toUpperCase()}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 12.0),
                          Opacity(
                              opacity: 0.7,
                              child: Text('Konu: ${subject["konu"]}')),
                          const SizedBox(height: 4.0),
                          Opacity(
                            opacity: 0.7,
                            child: Text(
                                'Oluşturulma Tarihi: ${ConstFunct.dateFormat(widget.ticket.created)}'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    const Opacity(
                      opacity: 0.7,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sohbet'),
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: widget.ticket.messages
                          .map((e) => defaultContainer(
                              context,
                              isDark,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.message),
                                  const SizedBox(height: 4.0),
                                  Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      'Cevap Tarihi: ${ConstFunct.dateFormat(e.created)}',
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                  )
                                ],
                              )))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Container defaultContainer(BuildContext context, bool isDark, Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0)
            ],
            borderRadius: BorderRadius.circular(8.0)),
        child: child);
  }
}
