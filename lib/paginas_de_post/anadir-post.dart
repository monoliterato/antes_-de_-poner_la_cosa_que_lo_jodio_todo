import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AnadirPost extends StatefulWidget {
  const AnadirPost({super.key});

  @override
  State<AnadirPost> createState() => _AnadirPostState();
}

class _AnadirPostState extends State<AnadirPost> {
  TextEditingController controllerTitulo = TextEditingController();
  TextEditingController controllerDescripcionCorta = TextEditingController();
  TextEditingController controllerDescripcionCompleta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Text(
              'AÑADIR NUEVA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 45.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'TITULO DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            width: 250,
            child: TextField(
              controller: controllerTitulo,
              obscureText: false,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                labelText: 'TITULO',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'DESCRIPCION CORTA DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: TextFormField(
              controller: controllerDescripcionCorta,
              maxLines: 3, // Número máximo de líneas visibles
              keyboardType: TextInputType
                  .multiline, // Habilita múltiples líneas en el teclado
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelText: 'Escribe tus notas aquí',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'SUBIR LA IMAGEN PRINCIPAL DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.only(bottom: 100.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/images/subir-dos.svg',
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 350,
                height: 350,
              ),
              label: const SizedBox.shrink(),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'DESCRIPCION COMPLETA DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: TextFormField(
              controller: controllerDescripcionCompleta,
              maxLines: 8, // Número máximo de líneas visibles
              keyboardType: TextInputType
                  .multiline, // Habilita múltiples líneas en el teclado
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelText: 'Escribe tus notas aquí',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Text(
            'SUBIR MAS IMAGENES PARA LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'AÑADIR POST',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),

          Container(height: 100),
        ],
      ),
    );
  }
}
