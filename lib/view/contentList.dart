import 'dart:convert';

import 'package:catalogo_khronos_app/model/post.dart';

// import 'package:html/dom.dart' as dom;
// import 'package:html/parser.dart';

import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:http/http.dart';

import 'package:flutter/services.dart';
import 'contentPage.dart';
import 'package:logging/logging.dart';
import 'package:monahawk_woocommerce/woocommerce.dart';

var posts;
int count = 1;
final _logger = Logger('ContentList');

class ContentList extends StatefulWidget {
  const ContentList({Key? key, required this.category}) : super(key: key);
  final WooProductCategory category;


  @override
  State<ContentList> createState() => new _DynamicList(this.category);
}

class _DynamicList extends State<ContentList> {
  final WooProductCategory category;
  _DynamicList(this.category);


  int page = 0;
  List<WooProduct> products = [];

  WooCommerce wooCommerce = WooCommerce(
      baseUrl: "https://danielqueiroz.com/catalogokhronos",
      consumerKey: "ck_6b222e090ea4707df784b3ee0f0b07b42d91e695",
      consumerSecret: "cs_ef70db5d8563ced826e6cad67b79737b5db633cd",
      isDebug: true);

  // ScrollController _scrollController = new ScrollController();

  getProducts() async {
    products = await wooCommerce.getProducts(category: category.id.toString());
    setState(() {});
    print(products.toString());
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  category.name?.toUpperCase() ?? 'Categoria',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .apply(color: Colors.blueGrey),
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 2,
                crossAxisSpacing: 1,
              ),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                final product = products[index];
                return InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyContentPage(product: product)));
                    },
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 230,
                      width: 200,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              product.images[0].src!,
                            ),
                            fit: BoxFit.cover),
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      //child: Image.network(product.images[0].src, fit: BoxFit.cover,),
                    ),
                    Text(
                      product.name ?? 'Carregando...',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: Colors.blueGrey, fontSizeFactor: 0.7),
                    ),
                    Text(
                      'SKU ${(product.sku ?? '')}',
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ));
              }, childCount: products.length),
            )
          ],
        ),
      ),
    );
  }


  Column getTile(Post post, Image image, BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: RichText(
            text: TextSpan(children: [
          getTitle(post.category),
          TextSpan(
            text: getDate(post.date),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          )
        ])),
      ),
      Stack(
        children: getImageList(post, image),
      ),
      Container(
        margin: EdgeInsets.only(top: 10),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "${post.title}. ",
            style:
                DefaultTextStyle.of(context).style.apply(fontWeightDelta: 10),
          ),
          TextSpan(
            // text: getDescription(post.excerpt),
            style: DefaultTextStyle.of(context).style,
          ),
          TextSpan(
            text: " Ver mais.",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ])),
      ),
    ]);
  }

  List<Widget> getImageList(Post post, Image image) {
    var isImageValid = post.image.length > 0;

    if (isImageValid) {
      return [
        image,
      ];
    } else {
      return [
        Text(
          post.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ];
    }
  }

  getDate(DateTime date) {
    var hoursPassed = new DateTime.now().difference(date);
    var year = date.year;
    var month = date.month;
    var day = date.day;
    var hour = date.hour;
    if (hoursPassed.inDays > 30) {
      var daysPassed = hoursPassed.inDays;
      var hourPassed = hoursPassed.inHours - (daysPassed * 24);

      return "Há $daysPassed dias e $hourPassed hora" +
          (hourPassed > 1 ? "s" : "");
    }
    if (hoursPassed.inDays > 30) {
      return "$day/$month/$year às $hour horas";
    }
    return "";
  }

  getCategoryColorBackground(String category) {
    switch (category.toUpperCase()) {
      case "FRIO":
        return Colors.blue;
      case "ESPORTES":
        return Color.fromRGBO(3, 45, 90, 1);
      case "SEGURANCA":
        return Color.fromRGBO(158, 28, 35, 1);
      case "NOTICIAS":
        return Color.fromRGBO(158, 28, 35, 1);
      case "ESTILO":
        return Color.fromRGBO(166, 163, 163, 1);
      case "POLITICA":
        return Color.fromRGBO(110, 153, 174, 1);
      case "CLIMA E TEMPO":
        return Color.fromRGBO(34, 158, 218, 1.0);
      case "SAUDE":
        return Color.fromRGBO(74, 203, 75, 1.0);
      case "COTIDIANO":
        return Color.fromRGBO(3, 45, 90, 1);
      default:
        return Color.fromRGBO(245, 248, 248, 1.0);
    }
  }

  getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case "FRIO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "ESPORTES":
        return Color.fromRGBO(252, 249, 249, 1.0);
      case "SEGURANCA":
        return Color.fromRGBO(250, 249, 249, 1.0);
      case "NOTICIAS":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "ESTILO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "POLITICA":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "CLIMA E TEMPO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "SAÚDE":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "COTIDIANO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      default:
        return Color.fromRGBO(255, 255, 255, 1.0);
    }
  }

  getTitle(String category) {
    return TextSpan(
      text: category.toUpperCase(),
      style: TextStyle(
          backgroundColor: getCategoryColorBackground(category),
          fontSize: 16,
          color: getCategoryColor(category),
          fontFamily: 'HurmeFIN1a',
          fontWeight: FontWeight.bold),
    );
  }
}
