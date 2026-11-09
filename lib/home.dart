import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List images = [
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: images.length,
      itemBuilder: (_, index) {
      return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(images[index]),
            fit: BoxFit.cover,
          ),
        ),
          child:LayoutGrid(
            columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
            rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
            children: [
              GridPlacement(

                columnStart: 1,
                columnSpan: 6,
                rowStart: 3,
                rowSpan: 1,
                
                child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: Text(
                                  'Bienvenido a la aplicación',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
              ),
              GridPlacement(
                
                columnStart: 1,
                columnSpan: 6,
                rowStart: 4,
                rowSpan: 3,
                
                child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: Text(
                                  'Bienvenido a la aplicación',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
              ),
              GridPlacement(
                
                columnStart: 1,
                columnSpan: 4,
                rowStart: 7,
                rowSpan: 1,
                
                child: FloatingActionButton(
                  onPressed: () {
                    // Acción al presionar el botón
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
      );
    });
  }
}
