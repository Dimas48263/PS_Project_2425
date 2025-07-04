import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/screens/admin/admin_expansion_tile.dart';
import 'package:zcap_net_app/features/settings/screens/admin/isar_explorer.dart';
import 'package:zcap_net_app/features/settings/screens/incidents/incident_types/incident_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/people/needs/special_needs_screen.dart';
import 'package:zcap_net_app/features/settings/screens/people/relation_type/relation_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/people/support/special_needs_screen.dart';
import 'package:zcap_net_app/features/settings/screens/zcaps/building_types/building_types_screen.dart';
import 'package:zcap_net_app/features/settings/screens/entities/entity_types/entity_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_level_detail_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_levels_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_record_detail_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_record_detail_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_data_access/user_data_access_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_profiles/user_profiles_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/users/users_screen.dart';
import 'package:zcap_net_app/features/settings/screens/zcaps/detail_type_categories/detail_type_categories_screen.dart';
import 'package:zcap_net_app/features/settings/screens/zcaps/zcap_detail_types/zcap_detail_types_screen.dart';
import 'package:zcap_net_app/features/settings/screens/zcaps/zcap_details/zcap_details_screen.dart';
import 'entities/entities/entities_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allowances = context.watch<UserAllowancesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_configs'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /* Hierarchical Tree tables */
            ExpansionTile(
              title: Text('screen_settings_structure'.tr()),
              leading: const Icon(Icons.account_tree),
              childrenPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                if (allowances.canRead('user_access_settings_tree_levels'))
                  ListTile(
                    title: Text('screen_settings_tree_levels'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TreeLevelsScreen()),
                      );
                    },
                  ),
                if (allowances.canRead('user_access_settings_tree_elements'))
                  ListTile(
                    title: Text('screen_settings_tree_elements'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TreesScreen()),
                      );
                    },
                  ),
                if (allowances
                    .canRead('user_access_settings_tree_detail_types'))
                  ListTile(
                    title: Text('screen_settings_detail_types'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TreeRecordDetailTypesScreen()),
                      );
                    },
                  ),
                if (allowances.canRead('user_access_settings_tree_details'))
                  ListTile(
                    title: Text('screen_settings_details'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TreeRecordDetailsScreen()),
                      );
                    },
                  ),
                if (allowances
                    .canRead('user_access_settings_tree_detail_association'))
                  ListTile(
                    title: Text('screen_settings_tree_level_detail_type'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TreeLevelDetailTypeScreen()),
                      );
                    },
                  ),
              ],
            ),
            const Divider(),

            /* Incident tables */
            ExpansionTile(
              title: Text('screen_settings_incidents'.tr()),
              leading: const Icon(Icons.report_problem_outlined),
              childrenPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                if (allowances.canRead('user_access_settings_incident_types'))
                  ListTile(
                    title: Text('screen_settings_incident_types'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IncidentTypesScreen()),
                      );
                    },
                  ),
              ],
            ),
            const Divider(),

            /* User tables */
            ExpansionTile(
              title: Text('screen_settings_users'.tr()),
              leading: const Icon(Icons.manage_accounts),
              childrenPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                Column(
                  children: [
                    if (allowances.canRead('user_access_settings_users'))
                      ListTile(
                        title: Text('screen_settings_users'.tr()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UsersScreen()),
                          );
                        },
                      ),
                    if (allowances
                        .canRead('user_access_settings_user_profiles'))
                      ListTile(
                        title: Text('screen_settings_user_profiles'.tr()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserProfilesScreen()),
                          );
                        },
                      ),
                    if (allowances.canRead('user_access_settings_users_data'))
                      ListTile(
                        title: Text('screen_settings_user_access_data'.tr()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserDataAccessScreen()), //TODO: access data Screen
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
            const Divider(),

            /* Support tables */
            ExpansionTile(
              title: Text('screen_settings_support_tables'.tr()),
              leading: const Icon(Icons.settings),
              childrenPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                ExpansionTile(
                    title: Text('screen_settings_entities'.tr()),
                    leading: const Icon(Icons.account_balance),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      Column(
                        children: [
                          if (allowances
                              .canRead('user_access_settings_entity_types'))
                            ListTile(
                              title: Text('screen_settings_entity_types'.tr()),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EntityTypesScreen()),
                                );
                              },
                            ),
                          if (allowances
                              .canRead('user_access_settings_entities'))
                            ListTile(
                              title: Text('screen_settings_entities'.tr()),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EntitiesScreen()),
                                );
                              },
                            ),
                        ],
                      ),
                    ]),
                ExpansionTile(
                    title: Text('screen_settings_zcap_buildings'.tr()),
                    leading: const Icon(Icons.maps_home_work_outlined),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      if (allowances
                          .canRead('user_access_settings_building_types'))
                        ListTile(
                          title: Text('screen_settings_building_types'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BuildingTypesScreen()),
                            );
                          },
                        ),
                      if (allowances
                          .canRead('user_access_settings_detail_category'))
                        ListTile(
                          title: Text('screen_settings_detail_category'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailTypeCategoriesScreen()),
                            );
                          },
                        ),
                      if (allowances
                          .canRead('user_access_settings_zcap_detail_type'))
                        ListTile(
                          title: Text('zcap_detail_type'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ZcapDetailTypesScreen()),
                            );
                          },
                        ),
                      /*if (allowances
                          .canRead('user_access_settings_detail_per_zcap'))
                        ListTile(
                          title: Text(
                              'screen_settings_zcap_building_details'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ZcapDetailsScreen()),
                            );
                          },
                        ),*/
                    ]),
                ExpansionTile(
                    title: Text('screen_settings_people'.tr()),
                    leading: const Icon(Icons.people),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      if (allowances.canRead(
                          'user_access_settings_people_relation_types'))
                        ListTile(
                          title: Text('screen_settings_relation_types'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RelationTypeScreen()),
                            );
                          },
                        ),
                      if (allowances
                          .canRead('user_access_settings_special_need_types'))
                        ListTile(
                          title:
                              Text('screen_settings_special_need_types'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialNeedsScreen()),
                            );
                          },
                        ),
                      if (allowances
                          .canRead('user_access_settings_support_need_types'))
                        ListTile(
                          title:
                              Text('screen_settings_support_need_types'.tr()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SupportNeededScreen()),
                            );
                          },
                        ),
                    ]),
              ],
            ),
            AdminExpansionTile(
              child: ListTile(
                title: Text('screen_settings_isar_db_explorer'.tr()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IsarExplorerScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
