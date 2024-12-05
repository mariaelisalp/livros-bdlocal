import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String idColumn = "idColumn";
String titleColumn = "titleColumn";
String authorColumn = "authorColumn";
String yearColumn = "yearColumn";
String genreColumn = "genreColumn";
String publisherColumn = "publisherColumn";
String coverColumn = "coverColumn";
String bookTable = "bookTable";

class BookHelper {
  static final BookHelper _instance = BookHelper.internal();
  factory BookHelper() => _instance;
  BookHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "books.db");
    return await openDatabase(path, version: 1, 
    onCreate: (Database db, int newVersion) async {
      await db.execute("CREATE TABLE $bookTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $authorColumn TEXT, $yearColumn TEXT, $genreColumn TEXT, $publisherColumn TEXT, $coverColumn TEXT)");
    });
  }

  Future<List<Book>> getAllBooks() async {
    Database dbBook = await db;
    List<Map<String,dynamic>> listMap = await dbBook.rawQuery("SELECT * FROM $bookTable");
    List<Book> listBook = [];
    for(Map<String,dynamic> m in listMap){
      listBook.add(Book.fromMap(m));
    }
  print(listMap);
    return listBook;

  }

  Future<Book?> getBook(int id) async{
    Database dbBook = await db;
    List<Map<String, dynamic>> maps = await dbBook.query(bookTable,
    columns: [idColumn, titleColumn, authorColumn, yearColumn, genreColumn, publisherColumn, coverColumn],
    where: "$idColumn = ?", whereArgs: [id]);

    if(maps.isNotEmpty){
      return Book.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  Future<Book> saveBook(Book book) async{
    Database dbBook = await db;
    book.id = await dbBook.insert(bookTable, book.toMap());
    return book;
  }

  Future<int> updateBook(Book book) async{
    print(book);
    Database dbBook = await db;
    return await dbBook.update(bookTable, book.toMap(),
    where: "$idColumn = ?", whereArgs: [book.id]);
  }
  
  Future<int> deleteBook(int id) async{
    Database dbBook = await db;
    return await dbBook.delete(bookTable,
    where: "$idColumn = ?", whereArgs: [id]);
  }
}


class Book {
  Book();

  int? id;
  String? title;
  String? year;
  String? author;
  String? genre;
  String? publisher;
  String? cover;

  Book.fromMap(Map map){
    id = map[idColumn];
    title = map[titleColumn];
    author = map[authorColumn];
    year = map[yearColumn];
    genre = map[genreColumn];
    publisher = map[publisherColumn];
    cover = map[coverColumn];
  }

  Map<String, Object?> toMap(){
    
    Map<String, Object?> map = {
      titleColumn : title,
      authorColumn : author,
      yearColumn : year,
      genreColumn : genre,
      publisherColumn : publisher,
      coverColumn : cover
    };

    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Book(id: $id, title: $title, author: $author, year: $year, genre: $genre, publisher: $publisher, cover: $cover)";
    
  }

}
