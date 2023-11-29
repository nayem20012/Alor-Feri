import 'package:demo_alor_feri/controller/cart_controller.dart';
import 'package:demo_alor_feri/pages/product_detail_page.dart';
import 'package:demo_alor_feri/widget/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/boxes.dart';
import '../model/note_model.dart';
import '../widget/product_grid_item.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  CartController cartController  = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    cartController.getCartItem();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart List"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var product = data[index];

              var name = product.name ?? "";
              var price = product.price ?? 0;
              var id = product.id ?? "";
              var url = product.url ?? "";
              var stock = product.stock_quantity ?? 0;

              return GestureDetector(
                  onTap: () {
                    Get.to(ProductDetailPage(
                        id: id,
                        name: name,
                        price: price,
                        stock_quantity: stock,
                        url: url,
                      value: true,
                    ));
                  },
                  child: CartItem(
                    id: id,
                    name: name,
                    url: url,
                    price: price,
                    stock: stock,
                    notesModel: product,
                  ));
            },
          );
        },
      ),
    );
  }
}
