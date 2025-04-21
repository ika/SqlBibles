// import 'dart:io';
// import 'package:sqlite3/sqlite3.dart';

import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

String filePath = './asv.csv';
String dbPath = './asv.db';
String tableName = 'asv';

void pacEsv() async {
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

    // Prepare a statement to run it multiple times:
    final stmt =
        db.prepare('INSERT INTO $tableName (b,c,v,o,t) VALUES (?,?,?,?,?)');

    if (await File(filePath).exists()) {
      final lines = utf8.decoder
          .bind(File(filePath).openRead())
          .transform(const LineSplitter());

      try {
        await for (final line in lines) {
          final split = line.split('|');

          final Map<int, String> values = {
            0: split[0],
            1: split[1],
            2: split[2],
          };

          final b = values[0];
          final c = values[1];
          final v = values[2];
          final o = 0;
          final t = split.sublist(3).join(',');

          // remove spaces
          //var t = lines[i].replaceAll(RegExp(r"\s+"), " ");

          print("working $b $c $v $o $t");

          stmt.execute([b, c, v, o, t]);
        }
      } catch (e) {
        print(e);
      }
    }

    stmt.dispose();
  } else {
    print("DATABASE EXISTS!");
  }
}

int calculate() {
  return 6 * 7;
}
