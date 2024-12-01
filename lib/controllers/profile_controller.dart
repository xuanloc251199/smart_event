import 'package:get/get.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();

  var units = <dynamic>[].obs;
  var faculties = <dynamic>[].obs;
  var classes = <dynamic>[].obs;

  var selectedUnit = Rxn<int>();
  var selectedFaculty = Rxn<int>();
  var selectedClass = Rxn<int>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    isLoading.value = true;
    try {
      units.value = await _repository.getUnits();
    } catch (e) {
      units.value = [];
      Get.snackbar('Error', 'Failed to load units');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFaculties(int unitId) async {
    isLoading.value = true;
    try {
      faculties.value = await _repository.getFaculties(unitId);
    } catch (e) {
      faculties.value = [];
      Get.snackbar('Error', 'Failed to load faculties');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClasses(int facultyId) async {
    isLoading.value = true;
    try {
      classes.value = await _repository.getClasses(facultyId);
    } catch (e) {
      classes.value = [];
      Get.snackbar('Error', 'Failed to load classes');
    } finally {
      isLoading.value = false;
    }
  }
}
