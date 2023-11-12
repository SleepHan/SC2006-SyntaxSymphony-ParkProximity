import 'package:parking/controller/FilterControllers/categoryFilterController.dart';
import 'package:parking/controller/FilterControllers/categoryFilterController.dart';
import 'package:parking/controller/FilterControllers/categoryFilterController.dart';
import 'package:parking/main.dart';
import 'package:flutter/material.dart';
import 'package:parking/controller/FilterControllers/Preferences.dart';
import 'package:parking/controller/FilterControllers/categoryController.dart';
import 'package:parking/controller/FilterControllers/filterRadiusController.dart';
import 'package:parking/controller/FilterControllers/radiusDistance.dart';
import 'package:parking/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/FilterControllers/categoryFilterController.dart';

class FilterPreferences extends StatefulWidget {
  const FilterPreferences({super.key});

  @override
  State<FilterPreferences> createState() => _FilterPreferencesState();
}

class _FilterPreferencesState extends State<FilterPreferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Filter Preferences')),
      bottomNavigationBar: BottomAppBar(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            },
            child: Text("Apply Filters"),
          )
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Radius Distance',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.blueAccent),
          ),
          CustomRadiusFilter(radiusDist: RadiusDistance.radiusDist),
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 10)),
          Text(
            'Carpark Availability',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.blueAccent),
          ),
          CustomCategoryFilter(
              categories: Category.categories, filters: FilterCategory.filters),
        ]),
      ),
    );
  }
}

class CustomCategoryFilter extends StatefulWidget {
  final List<Category> categories;
  final List<FilterCategory> filters;

  CustomCategoryFilter({
    required this.categories,
    Key? key,
    required this.filters,
  }) : super(key: key);

  @override
  State<CustomCategoryFilter> createState() => _CustomCategoryFilterState();
}

class _CustomCategoryFilterState extends State<CustomCategoryFilter> {
  late List<bool> isCheckedList;
  @override
  void initState() {
    super.initState();
    // Initialize isCheckedList with 'false' for each category
    isCheckedList = List.generate(widget.categories.length, (index) => false);
    loadCarParkAvailabilitySettings();
    loadCheckboxState();
  }

  Future<void> loadCarParkAvailabilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      settings.filterColorRed = prefs.getBool('red') ?? false;
      settings.filterColorYellow = prefs.getBool('yellow') ?? false;
      settings.filterColorGreen = prefs.getBool('green') ?? false;
      settings.carparkAvailabilityFilterID = prefs.getInt('settings') ?? 1;
    });
  }

  Future<void> saveCarParkAvailabilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('red', settings.red);
    await prefs.setBool('yellow', settings.yellow);
    await prefs.setBool('green', settings.green);
    await prefs.setInt('settings', settings.carparkAvailabilityFilter);
  }

  Future<void> loadCheckboxState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int index = 0; index < widget.categories.length; index++) {
        isCheckedList[index] = prefs.getBool('checkbox_$index') ?? false;
      }
    });
  }

  Future<void> saveCheckboxState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int index = 0; index < isCheckedList.length; index++) {
      await prefs.setBool('checkbox_$index', isCheckedList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.categories[index].color,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categories[index].name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: 25,
                child: Checkbox(
                  value: isCheckedList[index],
                  onChanged: (bool? newValue) {
                    setState(() {
                      isCheckedList[index] = newValue ?? false;
                      if (newValue == false) {
                        settings.setCarParkAvailabilityByIndexToggleOff(index);
                      } else if (newValue == true) {
                        settings.setCarParkAvailabilityByIndex(index);
                      }
                      saveCheckboxState();
                      saveCarParkAvailabilitySettings();
                      print('Red-- ${settings.red}');
                      print('Yellow-- ${settings.yellow}');
                      print('Green-- ${settings.green}');
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomRadiusFilter extends StatefulWidget {
  final List<RadiusDistance> radiusDist;
  const CustomRadiusFilter({required this.radiusDist, super.key});

  @override
  State<CustomRadiusFilter> createState() => _CustomRadiusFilterState();
}

class _CustomRadiusFilterState extends State<CustomRadiusFilter> {
  late int selectedRadiusIndex;
  @override
  void initState() {
    super.initState();
    loadSelectedIndex(); // Load the selected index from SharedPreferences

    // Initialize isCheckedList with 'false' for each category
    selectedRadiusIndex = -1;
  }

  void loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('selectedRadiusIndex') ?? -1;
    settings.radFilter = prefs.getDouble('settings.radRange') ?? 1.0;

    setState(() {
      selectedRadiusIndex = index;
    });
  }

  void saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedRadiusIndex', index);
    await prefs.setDouble('savedRadFilter', settings.radRange);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.radiusDist.asMap().entries.map((entry) {
        int index = entry.key;
        RadiusDistance filtersDistance = entry.value;
        return InkWell(
          onTap: () {
            setState(() {
              settings.setRadiusFilterByIndex(index);

              //final Preferences settings = Preferences();
              selectedRadiusIndex = index;
              // Set radFilter based on the selected index
              saveSelectedIndex(
                  index); // Save the selected index to SharedPreferences
            });
          },
          child: Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selectedRadiusIndex == index ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(filtersDistance.radius,
                style: Theme.of(context).textTheme.titleSmall),
          ),
        );
      }).toList(),
    );
  }
}
