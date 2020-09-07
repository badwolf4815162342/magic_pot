import 'dart:io';
import 'package:flutter/services.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'dart:math';

class DBApi {
  static Database _database;
  static final DBApi db = DBApi._();

  DBApi._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Series table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'magic_pot_manager.db');

    String rawStr = await rootBundle.loadString('assets/db/create_tables');
    List<String> initScript = rawStr.split("\n");

    String rawStrInsert = await rootBundle.loadString('assets/db/insert_objects');
    List<String> insertScript = rawStrInsert.split("\n");

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      initScript.forEach((script) async => await db.execute(script));
      insertScript.forEach((script) async => await db.execute(script));
    });
  }

// get Random ingredients for LevelSteps
  Future<List<Ingredient>> getXRandomObjects(int numberOfObjects) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Ingredients");

    List<Ingredient> list = res.isNotEmpty ? res.map((c) => Ingredient.fromJson(c)).toList() : [];

    List<Ingredient> currentObjects = List<Ingredient>();
    var random = new Random();

    var numbers = new List<int>();
    for (int i = 0; i < numberOfObjects; i++) {
      var randomInt = random.nextInt(list.length);
      // no duplicats
      while (numbers.contains(randomInt)) {
        randomInt = random.nextInt(list.length);
      }
      numbers.add(randomInt);
      currentObjects.add(list[randomInt]);
    }

    return currentObjects;
  }

  Future<Level> getLevelById(int currentLevelCounter) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> filteredList = list.where((level) => (level.id == currentLevelCounter)).toList();

    if (filteredList.length == 1) {
      return filteredList[0];
    } else {
      return null;
    }
  }

  Future<List<Level>> getLevelByDifficultyAndArchieved(Difficulty difficult) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> filteredList = list.where((level) => (level.difficulty == difficult && level.achievement)).toList();

    return filteredList;
  }

// Get all levels that are already achieved
  Future<List<Level>> getLevelByAchieved() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> filteredList = list.where((level) => (level.achievement)).toList();

    return filteredList;
  }

// Get all levels that are already achieved and are the last of a transformation
  Future<List<Level>> getFinalAchievedLevels() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> filteredList = list.where((level) => (level.finalLevel && level.achievement)).toList();

    return filteredList;
  }

// Get currently achieved level with highest difficulty
  Future<Level> getHighestLevel() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> allArchieved = list.where((level) => (level.achievement && !level.finalLevel)).toList();

    allArchieved.sort((a, b) => a.id.compareTo(b.id));
    return allArchieved.last;
  }

  Future<List<Animal>> getAllAnimals() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Animals");

    List<Animal> list = res.isNotEmpty ? res.map((c) => Animal.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<Animal>> getUnselectedAnimals() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Animals");

    List<Animal> list = res.isNotEmpty ? res.map((c) => Animal.fromJson(c)).toList() : [];

    List<Animal> filteredList = list.where((animal) => (!animal.isCurrent)).toList();

    return filteredList;
  }

// save selected animal and declare others as unselected
  Future<int> updateCurrentAnimal(Animal currentAnimal, List<Animal> animals) async {
    final db = await database;
    currentAnimal.isCurrent = true;
    int success = 1;
    for (Animal animal in animals) {
      animal.isCurrent = false;
      int i = await db.update(
        'animals',
        animal.toJson(),
        // Ensure that the Dog has a matching id.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [animal.id],
      );
      if (i == 0) {
        success = 0;
      }
    }
    int i = await db.update(
      'animals',
      currentAnimal.toJson(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [currentAnimal.id],
    );
    if (i == 0) {
      success = 0;
    }
    return success;
  }

  Future<int> updateLevel(Level level) async {
    final db = await database;

    return await db.update(
      'levels',
      level.toJson(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [level.id],
    );
  }

// save if animation of new achievement was already shown
  Future<void> updateLevelNotAnimated() async {
    final db = await database;
    await db.rawQuery("UPDATE Levels SET animated = '1' WHERE animated IS '0' AND achievement IS '1'");
  }

  Future<bool> newArchievements() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> allArchieved =
        list.where((level) => (level.achievement && !level.finalLevel && !level.animated)).toList();

    if (allArchieved.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> allArchieved() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM LEVELS");

    List<Level> list = res.isNotEmpty ? res.map((c) => Level.fromJson(c)).toList() : [];

    List<Level> allNotArchievedLevels = list.where((level) => (!level.achievement)).toList();

    if (allNotArchievedLevels.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
