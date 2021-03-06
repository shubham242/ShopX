import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders.dart';
import './screens/user_products_screen.dart';
import './screens/edit_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './models/custom_colors.dart';
import './models/custom_route.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, prevProd) => Products(
              auth.token,
              auth.userId,
              prevProd == null ? [] : prevProd.items,
            ),
            create: (ctx) => Products('', '', []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, prevOrders) => Orders(
              auth.token,
              auth.userId,
              prevOrders == null ? [] : prevOrders.orders,
            ),
            create: (ctx) => Orders('', '', []),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: CustomColors.primaryColor,
              accentColor: CustomColors.accentColor,
              canvasColor: CustomColors.canvasColor,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverview()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, ss) =>
                        ss.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetail.routeName: (ctx) => ProductDetail(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProducts.routeName: (ctx) => UserProducts(),
              EditProducts.routeName: (ctx) => EditProducts(),
            },
          ),
        ));
  }
}
