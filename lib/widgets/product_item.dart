import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../widgets/show_alert.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetail.routeName,
                  arguments: product.id,
                );
              },
              child: Container(
                color: Colors.white,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            footer: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '\$ ${product.price}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: Container(
                  width: 20,
                  child: Consumer<Cart>(
                    builder: (_, ctx, __) => IconButton(
                      padding: EdgeInsets.all(0),
                      icon: ctx.items.containsKey(product.id)
                          ? Icon(
                              Icons.shopping_cart,
                              size: 25,
                            )
                          : Icon(
                              Icons.shopping_cart_outlined,
                              size: 25,
                            ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        cart.addItem(
                          product.id,
                          product.price,
                          product.title,
                          product.imageUrl,
                        );
                        showAlertDialog(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          height: 30,
          top: 5,
          right: -10,
          child: Container(
            child: Consumer<Product>(
              builder: (ctx, product, _) => FloatingActionButton(
                heroTag: product.id,
                backgroundColor: Theme.of(context).canvasColor,
                child: Icon(
                  Icons.favorite,
                  color: product.isFav ? Color(0xFFff4342) : Colors.grey[350],
                  size: 25,
                ),
                onPressed: () {
                  product.toggleFav();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
