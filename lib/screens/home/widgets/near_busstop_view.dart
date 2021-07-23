import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bus/blocs/blocs.dart';
import 'package:my_bus/cubit/cubit.dart';
import 'package:my_bus/helpers/helpers.dart';
import 'package:my_bus/widgets/centered_text.dart';
import 'package:my_bus/widgets/widgets.dart';

class NearBusStopsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearBusCubit, NearBusState>(
      builder: (context, state) {
        if (state.status == NearBusStatus.loading) {
          return CenteredSpinner();
        } else if (state.status == NearBusStatus.no_location) {
          return CenteredTextButton(
              title: 'Location not enabled', subTitle: '', onTap: () {});
        } else if (state.status == NearBusStatus.no_permission) {
          return CenteredTextButton(
            title: 'Location Permission not set',
            subTitle: '',
            onTap: () {
              print('open settings');
              LocationRequest.openAppSettings();
              print('resume settings');
            },
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              final BusDataBloc bloc = context.read<BusDataBloc>();
              final NearBusCubit cubit = context.read<NearBusCubit>();
              if (state.data.isEmpty) {
                bloc..add(BusDataDownload());
                cubit.getNearMeBusStops();
              } else {
                cubit.getNearMeBusStops();
              }
            },
            child: ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return BusStopTile(item: item, showDistance: true);
              },
            ),
          );
        }
      },
    );
  }
}
