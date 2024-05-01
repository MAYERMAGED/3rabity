import 'package:abatiy/Classes/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class suppChat extends StatefulWidget {
  const suppChat({super.key});

  @override
  State<suppChat> createState() => _suppChatState();
}

class _suppChatState extends State<suppChat> {
  TextEditingController _controller = TextEditingController();
  bool isMessageEmpty=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(
            'Support',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 65),
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: _controller,
                  autocorrect: true,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          print('hello');
                          Message message = Message(
                              text: _controller.text,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverId: '27k015AakofyFTTNrHWuaoDSelA3',
                             );
                          message.sendMessage(message);
                          _controller.clear();
                        },
                        icon: Icon(Icons.send)),
                    label: Text('Send to',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
            ...List.generate(
              5,
              (index) {
                return Text('hello');

              },
            )
          ],
        ));
  }
}
//
// class sendField extends StatelessWidget {
//   TextEditingController controller;
//   sendField({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: EdgeInsets.only(bottom: 65),
//         alignment: Alignment.bottomCenter,
//         child: TextField(
//           controller: controller,
//           autocorrect: true,
//           minLines: 1,
//           maxLines: 5,
//           decoration: InputDecoration(
//             suffixIcon: IconButton(onPressed: () {
//     print('hello');
//     Message message=Message(
//     text: _controller.text,
//     senderId: FirebaseAuth.instance.currentUser!.uid,
//     receiverId: '27k015AakofyFTTNrHWuaoDSelA3',
//     dateTime: DateTime.now()
//     );
//     message.sendMessage(message);
//     }
//             }, icon: Icon(Icons.send)),
//             label: Text('Send to',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.w600)),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ));
//   }
// }
