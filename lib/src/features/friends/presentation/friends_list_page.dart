import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/friends/application/knot_cubit.dart';
import 'package:flutter_social_media/src/features/friends/application/knots_list_cubit/knots_list_cubit.dart';
import 'package:flutter_social_media/src/features/friends/components/already_knotted.dart';
import 'package:flutter_social_media/src/features/friends/components/knot_sent_received_options.dart';
import 'package:flutter_social_media/src/features/friends/domain/knot_model.dart';

class FriendsListPage extends StatefulWidget {
  static const String route = 'knots_list_page';
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<KnotModel> knots = [];
  List<KnotModel> requestedKnots = [];
  List<KnotModel> incomingKnots = [];

  List<KnotModel> activeKnotsOnUI = [];
  updateknotsListUI(List<KnotModel> list, String text) {
    setState(() {
      activeKnotsOnUI = list;
      isLoading = false;
      selectedKnot = text;
    });
  }

  bool isLoading = true;
  String selectedKnot = '';

  @override
  void initState() {
    _getAllKnotsList();
    super.initState();
  }

  _getAllKnotsList() {
    context.read<KnotsListCubit>().fetchKnots();
    context.read<KnotsListCubit>().fetchRequestedKnots();
    context.read<KnotsListCubit>().fetchIncomingKnots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Friends List'),
      body: BlocConsumer<KnotsListCubit, KnotsListState>(
        listener: (context, state) {
          state.mapOrNull(
            knotsLoaded: (val) {
              knots = val.knots;
              updateknotsListUI(knots, 'knots');
            },
            requestedKnotsLoaded: (val) {
              requestedKnots = val.knots;
            },
            incomingKnotsLoaded: (val) {
              incomingKnots = val.knots;
            },
          );
        },
        builder: (context, state) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              spacing: 14,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AppButton(
                        onTap: () => updateknotsListUI(knots, 'knots'),
                        label: 'Friends',
                        isOutlined: activeKnotsOnUI != knots,
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        onTap: () => updateknotsListUI(incomingKnots, 'incoming knots'),
                        label: 'Incoming',
                        isOutlined: activeKnotsOnUI != incomingKnots,
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        onTap: () => updateknotsListUI(requestedKnots, 'requested knots'),
                        label: 'Requested',
                        isOutlined: activeKnotsOnUI != requestedKnots,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: activeKnotsOnUI.isNotEmpty,
                  replacement: _emptyWarning(),
                  child: Expanded(
                    child: ListView.separated(
                      itemCount: activeKnotsOnUI.length,
                      itemBuilder: (context, i) {
                        var knot = activeKnotsOnUI[i];
                        return Card(
                          color: const Color.fromARGB(255, 148, 98, 98),
                          child: ListTile(
                            leading: ProfilePicBlob(profilePicUrl: knot.imageUrl),
                            title: Text(knot.name),
                            subtitle: Align(alignment: Alignment.centerRight, child: _buildTrailingWidget(knot.userId)),
                          ),
                        );
                      },
                      separatorBuilder: (_, _) => SizedBox(height: 8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailingWidget(String userId) {
    switch (selectedKnot) {
      case 'knots':
        return AlreadyKnotted();
      case 'requested knots':
        return KnotSentReceivedOptions(
          isIncomingKnotRequest: false,
          isOnlyButton: true,
          onAccept: () {},
          onReject: () {
            context.read<KnotCubit>().cancelKnotRequest(userId);
            _getAllKnotsList();
          },
        );
      case 'incoming knots':
        return KnotSentReceivedOptions(
          isIncomingKnotRequest: true,
          isOnlyButton: true,
          onAccept: () {
            context.read<KnotCubit>().acceptKnotRequest(userId);
            _getAllKnotsList();
          },
          onReject: () {
            context.read<KnotCubit>().rejectKnotRequest(userId);
            _getAllKnotsList();
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  Column _emptyWarning() {
    return Column(
      children: [
        Icon(Icons.info_outline, size: 42, color: AppColors.primaryColor.withValues(alpha: 0.33)),
        Text('no $selectedKnot!'),
      ],
    );
  }
}
