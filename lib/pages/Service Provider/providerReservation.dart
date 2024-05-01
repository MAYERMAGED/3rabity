import 'package:abatiy/Classes/reservation.dart';

import 'package:flutter/material.dart';

class providerReservation extends StatefulWidget {
  @override
  State<providerReservation> createState() => _providerReservationState();
}

class _providerReservationState extends State<providerReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
           IconButton(onPressed: (){}, icon: Icon(Icons.sort))
          ],
          backgroundColor: Colors.orangeAccent,
          title: Text(
            'Reservation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<reservation>>(
          future: reservation().getProviderReservations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            } else {
              if(snapshot.data==null || snapshot.data!.isEmpty)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/image/nodata.png'),
                    Text('No Reservation',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                );
              List<reservation> _providerReservations = snapshot.data!;
              return Container(
                child: ListView.builder(
                  itemCount: _providerReservations.length,
                  itemBuilder: (context, index) {
                    reservation _reservation = _providerReservations[index];
                    return InkWell(
                      // onLongPress: () {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: Text('Remove'),
                      //           content: Text(
                      //               'Are you Sure you want to Cancel this Service ?'),
                      //           actions: [
                      //             TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: Text('No')),
                      //             TextButton(
                      //                 onPressed: () {
                      //                   setState(() {});
                      //                 },
                      //                 child: Text('Yes')),
                      //           ],
                      //         );
                      //       });
                      //   setState(() {});
                      // },
                      child: Card(
                        child: ListTile(
                          minVerticalPadding: 25,
                          title: Text('${_reservation.ServiceName}'),
                          subtitle: Text(
                              "Date: ${_reservation.date!.day} / ${_reservation.date!.month} / ${_reservation.date!.year}\nTime: ${_reservation.time}"),
                          trailing: Text("${_reservation.reservationNumber}"),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
    throw UnimplementedError();
  }
}
