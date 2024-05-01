
import 'package:abatiy/Classes/request.dart';
import 'package:flutter/material.dart';


class requestPanel extends StatefulWidget {
  @override
  State<requestPanel> createState() => _requestPanelState();
}

class _requestPanelState extends State<requestPanel> {
  GlobalKey<FormState> _formState = GlobalKey();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String? Type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(
            'Request',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => setState(() {}),
                icon: Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.black,
                ))
          ],
        ),
        body: FutureBuilder<List<serviceRequest>>(
          future: serviceRequest().getAllRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('The error is ${snapshot.error}'),
              );
            } else {
              List<serviceRequest>? request = snapshot.data;
              if(snapshot.data!.isEmpty)
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/request.png'),
                      Container(
                        child: Text('No Requests',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      )
                    ],
                  ),
                );
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: request!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          color: Colors.grey[200],
                          child: ListTile(
                              minVerticalPadding: 40,
                              leading: Image.network('${request[index].imgUrl}',),
                              title: Text('${request[index].requestorName}'),
                              subtitle: Text('${request[index].requestId}'),
                              trailing: Container(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(right: 30),
                                        child: IconButton(
                                            onPressed: () {
                                              serviceRequest().deleteRequeset(
                                                  request[index].userId!);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.close))),
                                    Positioned(
                                        right: -10,
                                        child: IconButton(
                                            onPressed: () {
                                              serviceRequest().acceptRequest(
                                                  request[index].userId!);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.done))),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ))
                ],
              );
            }
          },
        ));
    throw UnimplementedError();
  }
}
