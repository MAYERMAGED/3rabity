// import 'package:abatiy/Classes/User.dart';
// import 'package:abatiy/Classes/reservation.dart';
// import 'package:flutter/material.dart';
//
// class reservationDetails extends StatelessWidget {
//   final reservation Reservation;
//
//   const reservationDetails({super.key, required this.Reservation});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${Reservation.reservationNumber}'),
//         centerTitle: true,
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: FutureBuilder<CurrentUser>(
//         future: CurrentUser().getUserbyID(Reservation.userId!),
//         builder: (context, snapshot) {
//           if(snapshot.connectionState==ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator(),);
//          else if(snapshot.hasError)
//             return Center(child: Text('Error is : ${snapshot.error}'),);
//          else {
//            if(snapshot.data==null)
//              return Center(child: Text('User was Deleted'),);
//            CurrentUser _user=snapshot.data!;
//            return
//           }
//         },
//       ),
//     );
//     throw UnimplementedError();
//   }
// }
