import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_search_cubit/profile_search_cubit.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/search/presentation/components/people_tab.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const route = 'search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _searchUsers() {
    if (_searchTerm.trim().isEmpty) return const Stream.empty();
    return FirebaseHelper.users
        .where('name_lower', isGreaterThanOrEqualTo: _searchTerm.toLowerCase())
        .where('name_lower', isLessThan: '${_searchTerm.toLowerCase()}\uf8ff')
        .snapshots();
  }

  void _setLoading(bool val) => setState(() => _isLoading = val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Search'),
      body: BlocListener<ProfileSearchCubit, ProfileSearchState>(
        listener: (context, state) {
          state.map(
            loading: (_) => _setLoading(true),
            error: (_) => _setLoading(false),
            loaded: (value) {
              _setLoading(false);
              switch (value.user.userType) {
                case UserType.individual:
                  context.pushNamed(
                    IndividualProfilePage.route,
                    extra: (
                      user: value.user,
                      individual: value.individualProfile,
                      business: value.businessProfile,
                      professional: value.professionalProfile,
                      contentCreator: value.contentCreatorProfile,
                    ),
                  );
                case UserType.business:
                case UserType.contentCreator:
                case UserType.professional:
              }
            },
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (v) => setState(() => _searchTerm = v.trim()),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [PeopleTab(stream: _searchUsers(), term: _searchTerm)],
                  ),
                ),
              ],
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Center(child: Text('$label coming soon'));
}
