import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'metodos_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ImageData {
  final String id;
  final String imageUrl;

  const ImageData({required this.id, required this.imageUrl});
}

const imageList = [
  ImageData(id: 'id-001', imageUrl: 'assets/images/1.jpg'),
  ImageData(id: 'id-002', imageUrl: 'assets/images/2.jpg'),
  ImageData(id: 'id-003', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-004', imageUrl: 'assets/images/4.jpg'),
  ImageData(id: 'id-005', imageUrl: 'assets/images/5.jpg'),
  ImageData(id: 'id-006', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-007', imageUrl: 'assets/images/7.jpg'),
  ImageData(id: 'id-008', imageUrl: 'assets/images/2.jpg'),
  ImageData(id: 'id-009', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-010', imageUrl: 'assets/images/4.jpg'),
  ImageData(id: 'id-011', imageUrl: 'assets/images/5.jpg'),
  ImageData(id: 'id-012', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-013', imageUrl: 'assets/images/7.jpg'),
  ImageData(id: 'id-014', imageUrl: 'assets/images/8.jpg'),
  ImageData(id: 'id-015', imageUrl: 'assets/images/9.jpg'),
  ImageData(id: 'id-016', imageUrl: 'assets/images/10.jpg'),
  ImageData(id: 'id-017', imageUrl: 'assets/images/3.jpg'),
  ImageData(id: 'id-018', imageUrl: 'assets/images/6.jpg'),
  ImageData(id: 'id-019', imageUrl: 'assets/images/7.jpg'),
];

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
              child: Text(
                'POST',
                textAlign: TextAlign.center,
                style: TextStyle(
                   color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  
                ),
              ),
            ),
          ),
          SliverMasonryGrid.count(
            crossAxisCount: 2,
            childCount: imageList.length,
            itemBuilder: (context, index) =>
                ImageCard(imageData: imageList[index]),
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 10.0,
            
          ),


          SliverToBoxAdapter(
            child: Container(
              //padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
             margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 80.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/post-page/anadir-post');
                },
                child: Text(
                  'final para añadir mas post',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                     color: Colors.black,
                    fontWeight: FontWeight.w600,
                  fontSize: 50,
                  
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}






//el diseño de una tarjeta





class ImageCard extends StatelessWidget {
  const ImageCard({required this.imageData});

  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomStart,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(imageData.imageUrl, fit: BoxFit.cover),
        ),
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

          decoration: BoxDecoration(
            color: Color.fromARGB(150, 30, 30, 30),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('dos', style: TextStyle(color: Colors.white)),
            Text('uno', style: TextStyle(color: Colors.red, fontSize: 25)),
          ],
        ),
      ],
    );
  }
}
