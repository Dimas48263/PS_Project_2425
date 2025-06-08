import 'package:flutter/material.dart';
import 'package:zcap_net_app/features/settings/screens/entity_types/entity_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/tree_levels/tree_levels_screen.dart';
import 'package:zcap_net_app/features/settings/screens/tree_record_detail_types/tree_record_detail_type_screen.dart';
import 'package:zcap_net_app/features/settings/screens/trees/tree_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_data_access/user_data_access_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_profiles/user_profiles_screen.dart';
import 'package:zcap_net_app/features/settings/screens/users/users/users_screen.dart';
import 'entity_types/entity_types_screen_old.dart';
import 'entities/entities_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            /* Hierarchical Tree tables */
            ExpansionTile(
              title: const Text("Estrutura"),
              leading: const Icon(Icons.account_tree),
              childrenPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ListTile(
                  title: const Text("Nível de Arvore"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TreeLevelsScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Elementos de Árvores"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TreesScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Tipos de detalhes"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TreeRecordDetailTypesScreen()),
                    );
                  },
                ),
              ],
            ),
            const Divider(),

            /* User tables */
            ExpansionTile(
              title: const Text("Utilizadores"),
              leading: const Icon(Icons.manage_accounts),
              children: [
                ListTile(
                  title: const Text("Utilizadores"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UsersScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Perfis de utilizador"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfilesScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Acesso a dados"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserDataAccessScreen()),
                    );
                  },
                ),
              ],
            ),
            const Divider(),

            /* Support tables */
            ExpansionTile(
              title: const Text("Tabelas Suporte"),
              leading: const Icon(Icons.settings),
              children: [
                ListTile(
                  title: const Text("Tipos Entidade OLD"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntityTypesScreenOld()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Tipos Entidade"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntityTypesScreen()),
                    );
                  },
                ),

                ListTile(
                  title: const Text("Entidades"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EntitiesScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
