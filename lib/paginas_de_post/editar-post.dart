import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditarPost extends StatefulWidget {
  const EditarPost({super.key});

  @override
  State<EditarPost> createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  TextEditingController controllerTitulo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Text(
            'AÑADIR NUEVA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          Text(
            'TITULO DE LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: controllerTitulo,
              obscureText: false,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TITULO',
              ),
            ),
          ),
          Text(
            'DESCRIPCION CORTA DE LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          TextFormField(
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
          Text(
            'SUBIR LA IMAGEN PRINCIPAL DE LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          SvgPicture.asset(
            'assets/images/subir-dos.svg',
            color: Colors.white,
            width: 350,
            height: 350,
          ),
          Text(
            'DESCRIPCION COMPLETA DE LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          TextFormField(
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
          Text(
            'SUBIR MAS IMAGENES PARA LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'ELIMINAR POST',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Container(height: 100),
        ],
      ),
    );
  }
}
