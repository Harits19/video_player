import 'dart:io';

import 'package:flutter/material.dart';

class FileView extends StatelessWidget {
  const FileView({
    Key? key,
    required this.file,
  }) : super(key: key);

  final List<FileSystemEntity> file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: file.isEmpty
            ? const Center(
                child: Text('Empty Directory'),
              )
            : ListView(
                children: [
                  ...file.map(
                    (e) => InkWell(
                      child: ListTile(
                        title: Text(e.toString()),
                      ),
                      onTap: () {
                        List<FileSystemEntity> files = [];
                        try {
                          files = Directory(e.path).listSync();
                        } catch (e) {
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FileView(file: files),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
