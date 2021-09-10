import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bus/cubit/cubit.dart';
import 'package:my_bus/models/models.dart';
import 'package:my_bus/repositories/bus_repository.dart';
import 'package:my_bus/screens/bus_route/cubit/cubit.dart';
import 'package:my_bus/screens/home/widgets/widgets.dart';
import 'package:my_bus/screens/screens.dart';
import 'package:my_bus/widgets/widgets.dart';

class BusArrivalList extends StatelessWidget {
  final Function onFlip;

  BusArrivalList({required this.onFlip});

  void _toggleFavorite(BuildContext context, bool isFavorite) {
    SelectedRoute selected = context.read<BusRepository>().selected;
    FavoritesCubit fave = context.read<FavoritesCubit>();
    if (isFavorite) {
      fave.removeFavorite(code: selected.code, service: selected.service);
    } else {
      fave.addFavorite(code: selected.code, service: selected.service);
    }
  }

  void _showRouteSheet(BuildContext context) {
    SelectedRoute selected = context.read<BusRepository>().selected;
    BusRouteCubit route = context.read<BusRouteCubit>();
    route.fetchRoute(service: selected.service);
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 2,
      context: context,
      builder: (context) {
        route.fetchRoute(service: selected.service, code: selected.code);
        return BusRouteScreen(service: selected.service, code: selected.code);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusArrivalCubit, BusArrivalState>(
      builder: (context, state) {
        if (state.status == BusArrivalStatus.loading) {
          return CenteredSpinner();
        } else if (state.status == BusArrivalStatus.no_internet) {
          return CenteredText(
              text: 'No Connection. Please check network connection.');
        } else {
          SelectedRoute selected = context.read<BusRepository>().selected;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.lightBlue.withOpacity(0.6),
                                Colors.lightBlue.withOpacity(0.2),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  highlightColor: Colors.lightBlue,
                                  onPressed: () {
                                    _showRouteSheet(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      selected.service,
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.white, height: 0),
                              Expanded(
                                child: RawMaterialButton(
                                  highlightColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => onFlip(),
                                  child: Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () {
                          SelectedRoute selected =
                              context.read<BusRepository>().selected;
                          context.read<BusArrivalCubit>().getBusArrival(
                              selected.code, selected.service, true);
                        },
                        child:
                            NextBusWidget(bus: state.data.firstBus, index: 1),
                      ),
                    ),
                    Expanded(
                      child: NextBusWidget(bus: state.data.secondBus, index: 2),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(310, -5),
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      SelectedRoute selected =
                          context.read<BusRepository>().selected;
                      if (state.status == FavoriteStatus.loading) {
                        return Container();
                      } else {
                        final isFavorite = state.data.contains(Favorite(
                            busStopCode: selected.code,
                            serviceNo: selected.service));
                        return IconButton(
                          onPressed: () => _toggleFavorite(context, isFavorite),
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: Colors.yellow.shade600,
                            size: 40,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Widget _nextBus({required NextBus bus, required int index}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Text(label[index] ?? 'No Svc',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15,
  //                 color: Colors.black54,
  //                 decoration: TextDecoration.underline)),
  //         bus.eta == 'NA'
  //             ? Text('No Svc', style: kArriving)
  //             : Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   Text.rich(
  //                     TextSpan(
  //                       children: [
  //                         TextSpan(
  //                             text: bus.eta,
  //                             style: bus.eta == 'Arriving'
  //                                 ? kArriving
  //                                 : kMinuteArrival),
  //                         bus.eta == 'Arriving'
  //                             ? TextSpan(text: '')
  //                             : int.parse(bus.eta) == 1
  //                                 ? TextSpan(text: 'min')
  //                                 : TextSpan(text: 'mins'),
  //                       ],
  //                     ),
  //                   ),
  //                   Text(kBusLoad[bus.load] ?? 'No Svc'),
  //                   Text(bus.feature == 'WAB' ? 'Wheelchair' : ''),
  //                 ],
  //               ),
  //       ],
  //     ),
  //   );
  // }
}
