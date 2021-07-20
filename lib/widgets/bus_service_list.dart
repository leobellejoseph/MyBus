import 'package:flutter/material.dart';
import 'package:my_bus/cubit/cubit.dart';
import 'package:my_bus/repositories/bus_repository.dart';

class BusServiceList extends StatelessWidget {
  final BusArrivalsState state;
  final Function onFlip;
  final BusRepository repository;
  BusServiceList(
      {required this.state, required this.onFlip, required this.repository});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1, crossAxisSpacing: 1, crossAxisCount: 2),
      itemBuilder: (context, index) {
        final item = state.data[index];
        final isFavorite = repository.isFavorite(
            service: item.serviceNo, code: item.busStopCode);
        return Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey,
                  ),
                ],
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.5),
                ),
                highlightColor: Colors.lightBlueAccent,
                onPressed: () => onFlip(item.serviceNo),
                child: Center(
                  child: Text(
                    item.serviceNo,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: isFavorite,
                child:
                    Icon(Icons.star, size: 15, color: Colors.yellow.shade500)),
          ],
        );
      },
    );
  }
}
