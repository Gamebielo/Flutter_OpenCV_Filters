import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_opencv/filters.dart';
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
  File? _file;
  Image? _image;

  List<FilterData> filters = [
    FilterData(name: "Hot", filter: FilterUtils.applyHot),
    FilterData(name: "Ocean", filter: FilterUtils.applyOcean),
    FilterData(name: "2D", filter: FilterUtils.applyFilter2D),
    FilterData(name: "Linhas", filter: FilterUtils.applyLines),
    FilterData(name: "Twilight", filter: FilterUtils.applyTwilight),
    FilterData(name: "Preto/Branco", filter: FilterUtils.applyThreshold),
  ];

  getImagePicker() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    var tempFile = File(pickedFile!.path);

    setState(() {
      _file = tempFile;
      _image = Image.file(tempFile);
    });
  }

  applyFilter() async {
    var bytes = await _file!.readAsBytes();
    var res = await ImgProc.blur(bytes, [45, 45], [20, 30], Core.borderReflect);

    setState(() {
      _image = Image.memory(res); // Criando imagem em memória
    });
  }

  cancelFilter() {
    setState(() {
      _image = Image.file(_file!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("OpenCV Filters"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey[850],
              width: double.maxFinite, // Máximo tamanho permitido na tela...
              height: 80,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Alinhando a linha no centro
                children: [
                  TextButton.icon(
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Adicionar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: getImagePicker,
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: cancelFilter,
                  )
                ],
              ),
            ),
            Expanded(
              // Para pegar o tamanho que sobrar da tela
              child: Container(
                alignment: Alignment.center,
                color: Colors.black,
                child: _image != null ? _image : null,
              ),
            ),
            Container(
              color: Colors.grey[850],
              width: double.maxFinite, // Máximo tamanho permitido na tela...,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(10.0),
                children: filters.map((f) {
                  return GestureDetector(
                    onTap: () async {
                      if (_file == null) return;

                      var result = await f.filter(_file!);
                      setState(() {
                        _image = result;
                      });
                    },
                    child: Container(
                      width: 80.0,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.white)),
                      child: Center(
                          child: Text(
                        f.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Scaffold permite montar a estrutura basica de uma tela
// Container serve para agrupar widgets
// ListView possui scroll
}
