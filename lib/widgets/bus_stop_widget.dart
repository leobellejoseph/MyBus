import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bus/cubit/cubit.dart';
import 'package:my_bus/repositories/bus_repository.dart';
import 'package:my_bus/screens/bus_route/cubit/bus_route_cubit.dart';
import 'package:my_bus/widgets/widgets.dart';

class BusStopWidget extends StatefulWidget {
  final String code;
  BusStopWidget({required this.code});
  @override
  _BusStopWidgetState createState() => _BusStopWidgetState();
}

class _BusStopWidgetState extends State<BusStopWidget>
    with WidgetsBindingObserver {
  final FlipCardController _flipCardController = FlipCardController();
  String service = '';
  @override
  void initState() {
    BlocProvider.of<BusRouteCubit>(context).fetchServices(code: widget.code);
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<BusArrivalsCubit>().getBusServices(widget.code);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusArrivalsCubit, BusArrivalsState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return LinearProgressIndicator();
        } else if (state.status == Status.no_internet) {
          return NoDataWidget(
              title: 'No Internet',
              subTitle: 'Please check connection settings.',
              caption: '',
              onTap: () {},
              showButton: false);
        } else if (state.status == Status.no_service) {
          return NoDataWidget(
              title: 'No Service',
              subTitle: '',
              caption: '',
              onTap: () {},
              showButton: false);
        } else {
          final repository = context.read<BusRepository>();
          return FlipCard(
            controller: _flipCardController,
            flipOnTouch: false,
            direction: FlipDirection.VERTICAL,
            front: BusServiceList(
                code: widget.code,
                state: state,
                onFlip: (service) {
                  if (service.isNotEmpty && widget.code.isNotEmpty) {
                    context
                        .read<BusArrivalCubit>()
                        .getBusArrival(widget.code, service, false);
                    _flipCardController.state?.toggleCard();
                  }
                },
                repository: repository),
            back: BusArrivalList(
              onFlip: () {
                _flipCardController.state?.toggleCard();
              },
            ),
          );
        }
      },
    );
  }
}
