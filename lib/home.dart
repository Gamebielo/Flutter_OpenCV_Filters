import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  File? file;
  Image? image;

  getImagePicker() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    var tempFile = File(pickedFile!.path);

    setState(() {
      file = tempFile;
      image = Image.file(tempFile);
    });
  }

  applyFilter() async {
    var bytes = await file!.readAsBytes();
    var res = await ImgProc.blur(bytes, [45, 45], [20, 30], Core.borderReflect);

    setState(() {
      image = Image.memory(res); // Criando imagem em memória
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("OpenCV Filters"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.green,
              width: double.maxFinite, // Máximo tamanho permitido na tela...
              height: 80,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Alinhando a linha no centro
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.add_a_photo_outlined),
                    label: Text("Adicionar"),
                    onPressed: getImagePicker,
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.cancel_outlined),
                    label: Text("Cancelar"),
                    onPressed: null,
                  )
                ],
              ),
            ),
            Expanded(
              // Para pegar o tamanho que sobrar da tela
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: image != null ? image : null,
              ),
            ),
            Container(
              color: Colors.blue,
              width: double.maxFinite, // Máximo tamanho permitido na tela...,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(10.0),
                children: [
                  GestureDetector(
                    onTap: applyFilter,
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 7.0),
                      child: Center(child: Text("Blur")),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    margin: EdgeInsets.only(right: 7.0),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    margin: EdgeInsets.only(right: 7.0),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    margin: EdgeInsets.only(right: 7.0),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    margin: EdgeInsets.only(right: 7.0),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Scaffold permite montar a estrutura basica de uma tela
// Container serve para agrupar widgets
// ListView possui scroll
