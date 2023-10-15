import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/tools/palette.dart';
import 'package:hack/tools/providers/displayed_objects.dart';
import 'package:provider/provider.dart';

class PinListScreen extends StatefulWidget {
  const PinListScreen({super.key});

  @override
  State<PinListScreen> createState() => _PinListScreenState();
}

class _PinListScreenState extends State<PinListScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the provider instance here
    final displayedObjectsProvider =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.watch<Palette>().darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate back to Map screen.
          },
        ),
        title: const Center(child: Text('List')),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchWidget(),
          Expanded(
            // Set the initial data as Offices, you can change this as required
            child: _buildList(data: displayedObjectsProvider.offices),
          ),
        ],
      ),
    );
  }

  bool _isOfficeActive = true; // Initial state. Adjust as required.

  Widget _buildSearchWidget() {
    return Container(
      color: context.watch<Palette>().greyBackground,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.watch<Palette>().greyBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск отделения',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: context.watch<Palette>().darkBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.watch<Palette>().darkBackground,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    color: Colors.white,
                    onPressed: () {
                      // Open filters dialog or another action
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              //border: Border.all(color: Color(0xFF686A6F)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: _isOfficeActive
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff0A2896), Color(0xff1E4BD2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        )
                      : BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              width: 1.5,
                              color: context.watch<Palette>().greyColor),
                        ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isOfficeActive = true;
                      });
                    },
                    child: Text(
                      'Offices',
                      style: TextStyle(
                        color: _isOfficeActive
                            ? Colors.white
                            : context.watch<Palette>().greyColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: _isOfficeActive
                      ? BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              width: 1.5,
                              color: context.watch<Palette>().greyColor),
                        )
                      : BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff0A2896), Color(0xff1E4BD2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isOfficeActive = false;
                      });
                    },
                    child: Text(
                      'ATMs',
                      style: TextStyle(
                        color: _isOfficeActive
                            ? context.watch<Palette>().greyColor
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList({required List data}) {
    data.sort((a, b) => a.radiusDistance.compareTo(b.radiusDistance));
    return Container(
      color: context.watch<Palette>().darkBackground,
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: context.watch<Palette>().dividerColor,
            thickness: 2,
          );
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.go('/office/${data[index].id}');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: context.watch<Palette>().blueIcon,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: Icon(Icons.place, color: Colors.white)),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].salePointName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'VTB Group UI',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[index].openHours[0].days ==
                                      'Не обслуживает ЮЛ'
                                  ? 'Часы работы: ${data[index].openHoursIndividual[0].hours}'
                                  : 'Часы работы: ${data[index].openHours[0].hours}',
                              style: TextStyle(
                                color: context.watch<Palette>().greyText,
                                fontFamily: 'VTB Group UI',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              '${data[index].radiusDistance.toInt()} м',
                              style: TextStyle(
                                color: context.watch<Palette>().greyText,
                                fontFamily: 'VTB Group UI',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
