import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/custom_widget/ingredient_draggable.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/util/logger.util.dart';

class LevelHelperUtil {
  final log = getLogger();

  static Future<List<Ingredient>> getIngredients(
      List<Ingredient> lastObjects, Level currentLevel) async {
    List<Ingredient> currentObjects = await DBApi.db
        .getXRandomObjects(currentLevel.numberOfObjectsToChooseFrom);

    return currentObjects;
  }

  static List<IngredientDraggable> getIngredientDraggables(
      List<Ingredient> objects) {
    List<IngredientDraggable> currentIngredientDraggables =
        new List<IngredientDraggable>();
    objects.forEach((element) {
      currentIngredientDraggables
          .add(new IngredientDraggable(ingredient: element));
    });
    return currentIngredientDraggables;
  }
}
