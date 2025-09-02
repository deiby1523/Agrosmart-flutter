// lib/presentation/widgets/dashboard_layout.dart (ACTUALIZADO)
import 'package:agrosmart_flutter/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 768;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context, isLargeScreen),
      drawer: isLargeScreen ? null : _buildDrawer(context),
      body: Row(
        children: [
          // Sidebar fijo para pantallas grandes
          if (isLargeScreen) _buildSidebar(context),
          // Contenido principal
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isLargeScreen) {
    final user = ref.watch(authProvider).value;
    final themeMode = ref.watch(themeNotifierProvider);
    // Detectar si está en modo oscuro
    bool isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return AppBar(
      elevation: 2,
      leading: isLargeScreen
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
      actions: [
        // Información del usuario
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => {
                    if (isDark)
                      {
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setTheme(ThemeMode.light),
                      }
                    else
                      {
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setTheme(ThemeMode.dark),
                      },
                  },
                  icon: isDark ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (mode) {
                    ref.read(themeNotifierProvider.notifier).setTheme(mode);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: ThemeMode.system,
                      child: Text('Seguir tema del sistema'),
                    ),
                    const PopupMenuItem(
                      value: ThemeMode.light,
                      child: Text('Claro'),
                    ),
                    const PopupMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Oscuro'),
                    ),
                  ],
                ),
                const SizedBox(width: 8),

                VerticalDivider(
                  indent: 15,
                  endIndent: 15,
                  thickness: 1,
                  color: const Color.fromARGB(129, 158, 158, 158),
                ),
                const SizedBox(width: 8),

                Icon(Icons.account_circle),
                const SizedBox(width: 8),
                Text(
                  user.email.split('@')[0],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium, // Solo la parte antes del @
                ),
              ],
            ),
          ),
        // Botón de logout
        PopupMenuButton<String>(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(child: _buildSidebarContent(context));
  }

  Widget _buildSidebarContent(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Column(
      children: [
        // // Header del sidebar
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).colorScheme.primaryContainer,
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Icon(
        //         Icons.agriculture,
        //         size: 40,
        //         color: Theme.of(context).colorScheme.primary,
        //       ),
        //       const SizedBox(height: 8),
        //       Text(
        //         'Dashboard',
        //         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //           color: Theme.of(context).colorScheme.onPrimaryContainer,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       Text(
        //         'Ganadería',
        //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        //           color: Theme.of(
        //             context,
        //           ).colorScheme.onPrimaryContainer.withOpacity(0.8),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Menú de navegación
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Home
              _buildMenuItem(
                context,
                icon: Icons.home,
                title: 'Home',
                route: '/dashboard',
                isSelected: currentRoute == '/dashboard',
              ),

              const SizedBox(height: 8),

              // Grupo Animales
              _buildGroupHeader(context, 'Animales'),
              _buildMenuItem(
                context,
                icon: Icons.category,
                title: 'Razas',
                route: '/breeds',
                isSelected: currentRoute == '/breeds',
                isGroupItem: true,
              ),

              // Aquí agregarás más items después:
              // _buildMenuItem(
              //   context,
              //   icon: Icons.pets,
              //   title: 'Animales',
              //   route: '/animals',
              //   isSelected: currentRoute == '/animals',
              //   isGroupItem: true,
              // ),

              // Más grupos vendrán aquí (Insumos, Reportes, etc.)
            ],
          ),
        ),

        // Footer del sidebar
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Versión 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    bool isSelected = false,
    bool isGroupItem = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(20)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: isGroupItem ? 16 : 8,
        vertical: 2,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.7),
          size: isGroupItem ? 20 : 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: isGroupItem ? 14 : 16,
          ),
        ),
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        dense: isGroupItem,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isGroupItem ? 24 : 16,
          vertical: isGroupItem ? 0 : 4,
        ),
        onTap: () {
          // Cerrar drawer en móvil
          if (MediaQuery.of(context).size.width <= 768) {
            Navigator.of(context).pop();
          }
          // Navegar
          context.go(route);
        },
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
