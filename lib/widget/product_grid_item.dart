import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';
import '../model/boxes.dart';
import '../model/note_model.dart';
import '../pages/payment_page.dart';
import '../value/const_image.dart';
import '../value/const_string.dart';

class ProductGridItem extends StatelessWidget {
  ProductGridItem(
      {super.key,
      required this.productName,
      required this.price,
      required this.id,
      required this.index,
      required this.url,
      required this.stock});

  int price;
  int index;
  int stock;

  String id;
  String productName;
  String url;

  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4,),
            Expanded(
              flex: 7,
              child: Container(
                  child: url.isNotEmpty
                      ? Center(
                          child: Image.network(
                            "${ConstString.serverUrl}$url",
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(ConstImage.blank)),
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text("৳ ${price.toString()} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${ConstString.available}: ${stock.toString()}",
                            maxLines: 1,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => TextButton(
                                onPressed: () {
                                  if (cartController.isCartAdded.contains(id)) {
                                    buyNow(context);
                                  } else {
                                    addToCart();
                                  }
                                },
                                child: Text(
                                  cartController.isCartAdded.contains(id)
                                      ? ConstString.checkOut
                                      : ConstString.addCart, style: const TextStyle(color: Colors.blue),
                                )),
                          )
                        ],
                      ),

                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> addToCart() async {
    final data = NotesModel(
        id: id, name: productName, url: url, price: price, stock_quantity: 1);
    final box = Boxes.getData();

    cartController.isCartAdded.value = [];
    for (int i = 0; i < box.length; i++) {
      var aaa = box.getAt(i);
      cartController.isCartAdded.add(aaa?.id);
    }

    if (cartController.isCartAdded.contains(id)) {
    } else {
      box.add(data);
      cartController.isCartAdded.add(id);
      cartController.saveCart();
    }
  }

  Future<void> buyNow(BuildContext context) async {
    Get.to(Payment(
      price: price,
      onTap: () {
        Get.snackbar(ConstString.payment, ConstString.paymentSuccessful);

        cartController.isCartAdded.remove(id);
        cartController.deleteCart(id);
        Navigator.pop(context);
      },
    ));
  }
}
