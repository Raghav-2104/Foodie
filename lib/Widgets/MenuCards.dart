// import 'package:flutter/material.dart';
// import 'package:vesit_canteen/Screens/AddToCart.dart';

// class FoodCards extends StatefulWidget {
//   const FoodCards({super.key});

//   @override
//   State<FoodCards> createState() => _FoodCardsState();
// }

// class _FoodCardsState extends State<FoodCards> {
//   List MenuList = [
//     ['Burger', '100', true],
//     ['Pizza', '200', true],
//     ['Vadapav', '50', true]
//   ];
//   Cart cart = Cart();
//   @override
//   Widget build(BuildContext context) {
//     print(MenuList[0][2]);
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: SafeArea(
//         child: ListView.builder(
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 child: ListTile(
//                     title: Text(MenuList[index][0].toString()),
//                     subtitle: Text('₹' + MenuList[index][1].toString()),
//                     trailing: Container(
//                       width: 110,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 50,
//                           ),
//                           MenuList[index][2]
//                               ? IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       MenuList[index][2] = false;
//                                       cart.addItems([
//                                         MenuList[index][0],
//                                         MenuList[index][1]
//                                       ]);
//                                       cart.printItems();
//                                     });
//                                   },
//                                   icon: Icon(Icons.add))
//                               : IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       MenuList[index][2] = true;
//                                       cart.removeItems([
//                                         MenuList[index][0],
//                                         MenuList[index][1]
//                                       ]);
//                                       cart.printItems();
//                                     });
//                                   },
//                                   icon: Icon(Icons.remove)),
//                         ],
//                       ),
//                     )),
//               ),
//             );
//           },
//           itemCount: MenuList.length,
//         ),
//       ),
//     );
//   }
// }
