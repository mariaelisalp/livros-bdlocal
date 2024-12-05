import 'dart:io';
import 'package:flutter/material.dart';
import 'package:livros_app/helpers/books_helper.dart';
import 'package:livros_app/view/book_page.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BookHelper helper = BookHelper();
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _getAllBooks();
  }

  void _getAllBooks() {
    helper.getAllBooks().then((list) {
      setState(() {
        books = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Image.asset(
            "assets/imgs/logo.png",
            height: 56,
            width: 1300,
          )),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showBookPage();
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal.shade300,
        focusColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return bookCard(context, index);
        },
      ),
    );
  }

  Widget bookCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        color: Colors.teal.shade50,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: books[index].cover != null &&
                            books[index].cover!.isNotEmpty
                        ? FileImage(File(books[index].cover!))
                        : AssetImage("assets/imgs/placeholder.png")
                            as ImageProvider,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      books[index].title ?? " ",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Autor: ${books[index].author ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ano de publicação: ${books[index].year ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                     Text(
                      "Gênero: ${books[index].genre ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                     Text(
                      "Editora: ${books[index].publisher ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                     
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showOptions(context, index);
      },
    );
  }

  void showBookPage({Book? book}) async {
    print("verificando se tem id ao passar: $book");
    final recBook = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookPage(book: book)),
    );

    if (recBook != null) {
      if (book != null) {
        await helper.updateBook(recBook);
        print("Editado");
      } else {
        await helper.saveBook(recBook);
        print("SALVO");
      }

      _getAllBooks();
    }
  }

  void showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        "Editar",
                        style:
                            TextStyle(color: Color(0xFF00796B), fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showBookPage(book: books[index]);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        confirmDelete(context, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir livro"),
          content: const Text("Tem certeza que deseja excluir esse livro?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                helper.deleteBook(books[index].id!).then((_) {
                  setState(() {
                    books.removeAt(index);
                  });
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Sim",
                style: TextStyle(color: Color(0xFF00695C)),
              ),
            ),
          ],
        );
      },
    );
  }
}
