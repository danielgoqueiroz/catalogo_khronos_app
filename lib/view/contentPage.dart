import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:monahawk_woocommerce/models/products.dart';

class MyContentPage extends StatefulWidget {
  MyContentPage({Key? key, required this.product}) : super(key: key);
  final WooProduct product;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.product);
}

class _MyHomePageState extends State<MyContentPage> {
  final WooProduct product;

  _MyHomePageState(this.product);

  @override
  Widget build(BuildContext context) {
    // dom.Document document = parse(post.content);
    //
    List<Widget> widgets = [];
    //
    Widget image = mainImageWidget(product);
    widgets.add(image);
    //
    titleWidgets(product, widgets);
    //
    // widgets.addAll(getContentWidgets(document));

    return Scaffold(
        appBar: AppBar(
            elevation: 5,
            shadowColor: Color.fromRGBO(253, 60, 60, 1.0),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(182, 0, 0, 1.0),
            title: Text(product.name ?? '')),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 230,
              width: 200,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      product.images[0].src ?? '',
                    ),
                    fit: BoxFit.cover),
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              //child: Image.network(product.images[0].src, fit: BoxFit.cover,),
            ),
            ...getContentWidgets(product.shortDescription.toString()),
            getAttributesWidgets()
          ],
        )));
  }

  getAttributesWidgets() {
    List<Widget> chips = [];
    product.attributes.forEach((att) {
      var chip = Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          att.name.toString() + " : " + att.options!.first.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      );
      chips.add(chip);
    });
    return Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: <Widget> [
          ...chips
        ]

    );
  }

}

  void titleWidgets(WooProduct product, List<Widget> widgets) {
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          product.name ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontFamily: 'Roboto'),
        ),
      ),
    ));
  }

  Widget mainImageWidget(WooProduct product) {
    var isImageValid = product.images.length > 0;
    Widget image = Stack(
      children: [
        Container(
          child: isImageValid
              ? Image.network(
                  product.images[0].src ?? '',
                  fit: BoxFit.scaleDown,
                  colorBlendMode: BlendMode.darken,
                )
              : null,
        ),
      ],
    );
    return image;
  }

  List<Widget> getContentWidgets(String html) {
    List<Widget> widgets = [];

    dom.Document document = parse(html);
    dom.Element body = document.getElementsByTagName('body')[0];
    body.nodes.forEach((element) {
      if (element is dom.Element) {
        getTextsWidget(element, widgets);
        // getImagesWidget(element, widgets);
        // getDivElements(element, widgets);
        // getCoteElement(element, widgets);
        // getReadMoreElement(element, widgets);
      }
    });
    return widgets;
  }

//
// void getDivElements(dom.Element element, List<Widget> widgets) async {
//   if (element.localName == 'div') {
//     getVideoComponent(element, widgets);
//   }
// }
//
// void getVideoComponent(dom.Element element, List<Widget> widgets) {
//   var nameClass = element.attributes['class'];
//   if (nameClass == 'youtube-responsive-container') {
//     var videoSource = element
//         .getElementsByTagName('iframe')
//         .elementAt(0)
//         .attributes['src']
//         .toString()
//         .split('embed/')[1];
//
//     YoutubePlayerController _controller = YoutubePlayerController(
//       initialVideoId: videoSource,
//       params: YoutubePlayerParams(
//         playlist: [videoSource], // Defining custom playlist
//         startAt: Duration(seconds: 30),
//         showControls: true,
//         showFullscreenButton: true,
//       ),
//     );
//
//     widgets.add(YoutubePlayerIFrame(
//       controller: _controller,
//       aspectRatio: 16 / 9,
//     ));
//   }
//   element.getElementsByClassName('player-content').forEach((element) {
//     widgets.add(
//       Text('player-content'),
//     );
//   });
// }
//
// void getImagesWidget(dom.Element element, List<Widget> widgets) {
//   if (element.localName == 'div') {
//     var classText = element.attributes['class'];
//     var isGaleryElement =
//         classText.toString().contains('galeria-de-fotos-slider');
//     if (isGaleryElement) {
//       var fotosElements = element.getElementsByTagName('img');
//       var carrousel = CarouselSlider(
//         options: CarouselOptions(height: 250.0),
//         items: fotosElements.map((i) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.all(5),
//                   child: Image.network(
//                     i.attributes['data-src'].toString(),
//                     fit: BoxFit.scaleDown,
//                   ));
//             },
//           );
//         }).toList(),
//       );
//       widgets.add(carrousel);
//     } else {
//       element.getElementsByTagName('img').forEach((imgElement) {
//         var containsAtt = imgElement.attributes.containsKey('src');
//         String link = containsAtt
//             ? imgElement.attributes['src']!
//             : imgElement.attributes['data-src']!;
//         // String description = element.getElementsByTagName('span')[0].text;
//
//         var image = Image.network(
//           link,
//           fit: BoxFit.fitWidth,
//         );
//         widgets.add(Container(
//           child: Stack(children: [
//             image,
//             Positioned(
//               bottom: 0,
//               width: MediaQuery.of(context).size.width,
//               child: Text("imagem",
//                   style: TextStyle(
//                       backgroundColor: Colors.black.withOpacity(0.4),
//                       fontSize: 12,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 1.0,
//                           color: Colors.black,
//                           offset: Offset(1.0, 1.0),
//                         ),
//                       ])),
//             )
//           ]),
//         ));
//       });
//     }
//   }
// }
//
  void getTextsWidget(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'p') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(element.text,
            style: TextStyle(
              fontSize: 16,
            )),
      ));
    }
  }
//
// String getText(String excerpt) {
//   dom.Document document = parse(excerpt);
//   return document.getElementsByTagName("p").first.innerHtml;
// }
//
// void getCoteElement(dom.Element element, List<Widget> widgets) {
//   if (element.localName == 'blockquote') {
//     widgets.add(Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Text(element.text,
//           style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
//     ));
//   }
// }
//
// void getReadMoreElement(dom.Element element, List<Widget> widgets) {
//   if (element.localName == 'ul') {
//     widgets.add(Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Text(element.text,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//     ));
//   }
// }
// }
