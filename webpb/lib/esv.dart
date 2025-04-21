import 'dart:io';
import 'dart:core';
import 'package:xml/xml.dart';
import 'package:sqlite3/sqlite3.dart';

String dbPath = './webpb.db';
String tableName = 'webpb';

const Map<String, int> BookMappings = {
  'GEN': 1,
  'EXO': 2,
  'LEV': 3,
  'NUM': 4,
  'DEU': 5,
  'JOS': 6,
  'JDG': 7,
  'RUT': 8,
  '1SA': 9,
  '2SA': 10,
  '1KI': 11,
  '2KI': 12,
  '1CH': 13,
  '2CH': 14,
  'EZR': 15,
  'NEH': 16,
  'EST': 17,
  'JOB': 18,
  'PSA': 19,
  'PRO': 20,
  'ECC': 21,
  'SNG': 22,
  'ISA': 23,
  'JER': 24,
  'LAM': 25,
  'EZK': 26,
  'DAN': 27,
  'HOS': 28,
  'JOL': 29,
  'AMO': 30,
  'OBA': 31,
  'JON': 32,
  'MIC': 33,
  'NAM': 34,
  'HAB': 35,
  'ZEP': 36,
  'HAG': 37,
  'ZEC': 38,
  'MAL': 39,
  'MAT': 40,
  'MRK': 41,
  'LUK': 42,
  'JHN': 43,
  'ACT': 44,
  'ROM': 45,
  '1CO': 46,
  '2CO': 47,
  'GAL': 48,
  'EPH': 49,
  'PHP': 50,
  'COL': 51,
  '1TH': 52,
  '2TH': 53,
  '1TI': 54,
  '2TI': 55,
  'TIT': 56,
  'PHM': 57,
  'HEB': 58,
  'JAS': 59,
  '1PE': 60,
  '2PE': 61,
  '1JN': 62,
  '2JN': 63,
  '3JN': 64,
  'JUD': 65,
  'REV': 66
};

void main() async {
  if (!await File(dbPath).exists()) {
    final db = sqlite3.open(dbPath);

    db.execute('''
        CREATE TABLE $tableName (
          id INTEGER NOT NULL PRIMARY KEY,
          b INTEGER DEFAULT 0,
          c INTEGER DEFAULT 0,
          v INTEGER DEFAULT 0,
          o INTEGER DEFAULT 0,
          t TEXT DEFAULT ''
        );
  ''');

    final stmt =
        db.prepare('INSERT INTO $tableName (b,c,v,o,t) VALUES (?,?,?,?,?)');

    final file = new File('engwebpb_vpl.xml');
    final document = XmlDocument.parse(file.readAsStringSync());

    var root = document.rootElement;

    var vElements = root.findAllElements('v');

    print('Working ....');

    db.execute('BEGIN;');
    
    for (var v in vElements) {
      var bValue = v.getAttribute('b');
      var cValue = v.getAttribute('c');
      var vValue = v.getAttribute('v');
      var oValue = 0;
      var tValue = v.innerText;

      if (BookMappings.containsKey(bValue)) {
        bValue = BookMappings[bValue].toString();
      }

      stmt.execute([bValue, cValue, vValue, oValue, tValue]);

      //print('b=$bValue, c=$cValue, v=$vValue, t=\'$tValue\'');
    }

      db.execute('COMMIT;');

      stmt.dispose();

  } else {
    print("DATABASE EXISTS!");
  }
}
  
//------------------------------
// code to make BookList
//------------------------------
//int cnt =1;
//List<String> usedlist = [];
//File outfile = new File("books.txt");
//if(!usedlist.contains(bValue)) {
//outfile.writeAsStringSync("'$bValue':$cnt,\n",mode: FileMode.append, flush: true); //, mode: FileMode.append);
//usedlist.insert(0, "$bValue");
//cnt++;
