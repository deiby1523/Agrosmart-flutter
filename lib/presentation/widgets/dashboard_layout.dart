// =============================================================================
// DASHBOARD LAYOUT - Layout Principal de la Aplicación
// =============================================================================
// Layout principal que proporciona la estructura de navegación y disposición
// visual para la aplicación AgroSmart.
//
// Características:
// - Diseño responsive (mobile/desktop)
// - Sidebar colapsable en mobile, fijo en desktop
// - Sistema de temas (light/dark/system)
// - Navegación declarativa con GoRouter
// - Gestión de autenticación y sesión de usuario
//
// Flujo responsive:
// - Mobile: Drawer lateral deslizable
// - Desktop: Sidebar fijo permanente
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/user.dart';
import 'package:agrosmart_flutter/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

/// ---------------------------------------------------------------------------
/// # DashboardLayout
///
/// Layout principal que envuelve el contenido de la aplicación con:
/// - AppBar con controles de usuario y tema
/// - Sistema de navegación lateral responsive
/// - Gestión de estado de autenticación
/// - Soporte para temas claro/oscuro
///
/// Utiliza `ConsumerStatefulWidget` para interactuar con providers de
/// autenticación y tema mediante Riverpod.
/// ---------------------------------------------------------------------------
class DashboardLayout extends ConsumerStatefulWidget {
  final Widget child; // Contenido principal que se renderiza en el layout
  // TODO: Agregar informacion personalizada para poner en el appbar

  const DashboardLayout({super.key, required this.child});

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

// =============================================================================
// _DashboardLayoutState
// =============================================================================
// Estado del layout principal del dashboard.
//
// Responsabilidades:
// - Gestión del estado responsive (mobile/desktop)
// - Control del drawer/scaffold mediante GlobalKey
// - Renderizado condicional de sidebar/drawer
// - Manejo de navegación y rutas
// - Gestión de temas y preferencias de usuario
// =============================================================================
class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  // ===========================================================================
  // CONSTANTES Y CONFIGURACIÓN
  // ===========================================================================
  static const _desktopBreakpoint = 768.0; // Breakpoint para desktop/tablet
  static const _sidebarWidth = 250.0; // Ancho fijo del sidebar en desktop
  static const _userInfoSpacing = 8.0; // Espaciado en información de usuario
  static const _verticalDividerIndent = 15.0; // Indentado del divisor vertical

  // Key para controlar el scaffold y abrir el drawer en mobile
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ===========================================================================
  // CONSTRUCCIÓN PRINCIPAL
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # build()
  ///
  /// Construye la estructura principal del dashboard con:
  /// - Scaffold con AppBar y cuerpo responsive
  /// - Sidebar fijo en desktop / Drawer en mobile
  /// - Contenido principal adaptativo
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > _desktopBreakpoint;

    return Scaffold(
      key: _scaffoldKey,
      // appBar: _buildAppBar(context, isLargeScreen),
      drawer: isLargeScreen ? null : _buildDrawer(context),
      body: _buildBody(context, isLargeScreen),
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - CONSTRUCCIÓN DE ESTRUCTURA PRINCIPAL
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _buildBody()
  ///
  /// Construye el cuerpo principal del layout con disposición responsive.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  /// - `isLargeScreen`: Indica si está en modo desktop
  ///
  /// Returns:
  /// - `Widget` con la estructura body completa
  /// --------------------------------------------------------------------------
  Widget _buildBody(BuildContext context, bool isLargeScreen) {
    final session = ref.watch(authProvider).value;
    final user = session?.user;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = _calculateIsDark(themeMode, context);

    final theme = Theme.of(context);
    return Row(
      children: [
        // Sidebar fijo en pantallas grandes
        if (isLargeScreen) _buildSidebar(context),

        // Área principal de contenido
        // Expanded(
        //   child: Container(
        //     color: Theme.of(context).colorScheme.surface,
        //     child: widget.child,
        //   ),
        // ),
        Expanded(
          child: Column(
            children: [
              // Top Bar
              SafeArea(
                child: Container(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        if (!isLargeScreen)
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: _userInfoSpacing,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildThemeToggleButton(isDark, context),
                              _buildThemeMenuButton(context),
                              const SizedBox(width: _userInfoSpacing),
                              _buildUserInfoSection(user!, context),
                              _buildLogoutMenuButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Content Area
              Expanded(
                child: Padding(
                  padding: isLargeScreen
                      ? const EdgeInsets.symmetric(horizontal: 30)
                      : const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - CONSTRUCCIÓN DE APP BAR
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _buildAppBar()
  ///
  /// Construye la AppBar superior con controles de usuario y tema.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  /// - `isLargeScreen`: Indica si está en modo desktop
  ///
  /// Returns:
  /// - `PreferredSizeWidget` configurado como AppBar
  /// --------------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isLargeScreen) {
    final session = ref.watch(authProvider).value;
    final user = session?.user;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = _calculateIsDark(themeMode, context);

    return AppBar(
      elevation: 2,
      leading: _buildAppBarLeading(isLargeScreen),
      actions: _buildAppBarActions(user, isDark, context),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildAppBarLeading()
  ///
  /// Construye el leading de la AppBar (menú hamburguesa en mobile).
  ///
  /// Parameters:
  /// - `isLargeScreen`: Indica si está en modo desktop
  ///
  /// Returns:
  /// - `Widget` con el leading apropiado o `null`
  /// --------------------------------------------------------------------------
  Widget? _buildAppBarLeading(bool isLargeScreen) {
    if (isLargeScreen) return null;

    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildAppBarActions()
  ///
  /// Construye las acciones de la AppBar (controles de tema y usuario).
  ///
  /// Parameters:
  /// - `user`: Usuario actual (puede ser null)
  /// - `isDark`: Indica si el tema actual es oscuro
  ///
  /// Returns:
  /// - `List<Widget>` con todas las acciones de la AppBar
  /// --------------------------------------------------------------------------
  List<Widget> _buildAppBarActions(
    User? user,
    bool isDark,
    BuildContext context,
  ) {
    if (user == null) return [];

    return [
      Padding(
        padding: const EdgeInsets.only(right: _userInfoSpacing),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeToggleButton(isDark, context),
            _buildThemeMenuButton(context),
            const SizedBox(width: _userInfoSpacing),
            _buildUserInfoSection(user, context),
            _buildLogoutMenuButton(context),
          ],
        ),
      ),
    ];
  }

  /// --------------------------------------------------------------------------
  /// # _buildThemeToggleButton()
  ///
  /// Construye el botón de cambio rápido de tema (dark/light).
  ///
  /// Parameters:
  /// - `isDark`: Indica si el tema actual es oscuro
  ///
  /// Returns:
  /// - `IconButton` configurado para cambio de tema
  /// --------------------------------------------------------------------------
  Widget _buildThemeToggleButton(bool isDark, BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () {
        final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
        ref.read(themeNotifierProvider.notifier).setTheme(newTheme);
      },
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildThemeMenuButton()
  ///
  /// Construye el menú de selección de tema (system/light/dark).
  ///
  /// Returns:
  /// - `PopupMenuButton` con opciones de tema
  /// --------------------------------------------------------------------------
  Widget _buildThemeMenuButton(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<ThemeMode>(
      position: PopupMenuPosition.under,
      icon: Icon(
        Icons.more_vert_rounded,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      onSelected: (mode) {
        ref.read(themeNotifierProvider.notifier).setTheme(mode);
      },
      itemBuilder: (context) => _buildThemeMenuItems(),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildThemeMenuItems()
  ///
  /// Construye los items del menú de temas.
  ///
  /// Returns:
  /// - `List<PopupMenuItem<ThemeMode>>` con opciones de tema
  /// --------------------------------------------------------------------------
  List<PopupMenuItem<ThemeMode>> _buildThemeMenuItems() {
    return [
      const PopupMenuItem(
        value: ThemeMode.system,
        child: Text(_Texts.themeSystem),
      ),
      const PopupMenuItem(
        value: ThemeMode.light,
        child: Text(_Texts.themeLight),
      ),
      const PopupMenuItem(value: ThemeMode.dark, child: Text(_Texts.themeDark)),
    ];
  }

  /// --------------------------------------------------------------------------
  /// # _buildUserInfoSection()
  ///
  /// Construye la sección de información del usuario.
  ///
  /// Parameters:
  /// - `user`: Usuario actual
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `Row` con información del usuario
  /// --------------------------------------------------------------------------
  Widget _buildUserInfoSection(User user, BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Separador visual
        VerticalDivider(
          indent: _verticalDividerIndent,
          endIndent: _verticalDividerIndent,
          thickness: 1,
          color: const Color.fromARGB(129, 158, 158, 158),
        ),
        const SizedBox(width: _userInfoSpacing),

        // Icono y nombre de usuario
        Icon(
          Icons.account_circle,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        const SizedBox(width: _userInfoSpacing),
        Text(
          user.email.split('@')[0], // Solo la parte antes de @
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: _userInfoSpacing),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildLogoutMenuButton()
  ///
  /// Construye el menú de logout.
  ///
  /// Returns:
  /// - `PopupMenuButton` con opción de cerrar sesión
  /// --------------------------------------------------------------------------
  Widget _buildLogoutMenuButton(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      onSelected: _handleMenuAction,
      itemBuilder: (context) => _buildLogoutMenuItems(),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildLogoutMenuItems()
  ///
  /// Construye los items del menú de logout.
  ///
  /// Returns:
  /// - `List<PopupMenuItem<String>>` con opción de logout
  /// --------------------------------------------------------------------------
  List<PopupMenuItem<String>> _buildLogoutMenuItems() {
    return [
      const PopupMenuItem(
        value: 'logout',
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: _userInfoSpacing),
            Text(_Texts.logout),
          ],
        ),
      ),
    ];
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - CONSTRUCCIÓN DE SIDEBAR/DRAWER
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _buildSidebar()
  ///
  /// Construye el sidebar lateral para desktop.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `Widget` con el sidebar de desktop
  /// --------------------------------------------------------------------------
  Widget _buildSidebar(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: _sidebarWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.sidebarGradient1,
            colors.sidebarGradient2,
            colors.sidebarGradient3,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _buildSidebarContent(context),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildDrawer()
  ///
  /// Construye el drawer para mobile.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `Widget` con el drawer de mobile
  /// --------------------------------------------------------------------------
  Widget _buildDrawer(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.sidebarGradient1,
              colors.sidebarGradient2,
              colors.sidebarGradient3,
            ],
          ),
        ),
        child: _buildSidebarContent(context),
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildSidebarContent()
  ///
  /// Construye el contenido común del sidebar/drawer.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `Widget` con el contenido de navegación
  /// --------------------------------------------------------------------------
  Widget _buildSidebarContent(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          // Encabezado con logo y nombre del software
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logotipo
                Image.asset('assets/logos/logo.png', width: 40, height: 40),
                const SizedBox(width: 12),
                // Nombre del software
                Text(
                  'AgroSmart',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // const Divider(thickness: 1),

          // Menú de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_rounded,
                  title: 'Panel Principal',
                  route: '/dashboard',
                  isSelected: currentRoute == '/dashboard',
                  isGroupItem: true,
                ),

                const SizedBox(height: 16),

                _buildGroupHeader(context, 'Finca'),
                _buildMenuItem(
                  context,
                  icon: Icons.fence_rounded, // O Icons.fence
                  title: 'Potreros',
                  route: '/paddocks',
                  isSelected: currentRoute == '/paddocks',
                  isGroupItem: true,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.compost_rounded,
                  title: 'Insumos',
                  route: '/supplies',
                  isSelected: currentRoute == '/supplies',
                  isGroupItem: true,
                ),

                const SizedBox(height: 16),

                _buildGroupHeader(context, 'Control de Ganado'),
                _buildMenuItem(
                  context,
                  icon: Icons.grid_view_rounded, // Icono de grupos para Lotes
                  title: 'Lotes',
                  route: '/lots',
                  isSelected: currentRoute == '/lots',
                  isGroupItem: true,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.pets_rounded,
                  title: 'Razas',
                  route: '/breeds',
                  isSelected: currentRoute == '/breeds',
                  isGroupItem: true,
                ),
                _buildMenuItem(
                  context,
                  svgAsset: 'assets/icons/cow_icon.svg',
                  title: 'Animales',
                  route: '/animals',
                  isSelected: currentRoute.startsWith('/animals'),
                  isGroupItem: true,
                ),

                const SizedBox(height: 16),

                _buildGroupHeader(context, 'Producción'),
                _buildMenuItem(
                  context,
                  icon: Icons.grass_rounded, // O Icons.Agriculture
                  title: 'Alimentación',
                  route: '/feedings',
                  isSelected: currentRoute.startsWith('/feedings'),
                  isGroupItem: true,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.local_drink_rounded,
                  title: 'Ordeños',
                  route: '/milkings',
                  isSelected: currentRoute.contains('milkings'),
                  isGroupItem: true,
                ),
                
              ],
            ),
          ),

          _buildSidebarFooter(context),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildSidebarFooter()
  ///
  /// Construye el footer del sidebar con información de versión.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `Widget` con el footer del sidebar
  /// --------------------------------------------------------------------------
  Widget _buildSidebarFooter(BuildContext context) {
    return const Column(
      children: [
        // Divider(),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            _Texts.version,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - ELEMENTOS DE NAVEGACIÓN
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _buildGroupHeader()
  ///
  /// Construye el encabezado de grupo en el sidebar.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  /// - `title`: Título del grupo
  ///
  /// Returns:
  /// - `Widget` con el header del grupo
  /// --------------------------------------------------------------------------
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

  /// --------------------------------------------------------------------------
  /// # _buildMenuItem()
  ///
  /// Construye un item individual del menú de navegación.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  /// - `icon`: Icono del item
  /// - `title`: Título del item
  /// - `route`: Ruta de destino
  /// - `isSelected`: Indica si es la ruta actual
  /// - `isGroupItem`: Indica si es item de grupo (estilo compacto)
  ///
  /// Returns:
  /// - `Widget` con el item de menú configurado
  /// --------------------------------------------------------------------------
  Widget _buildMenuItem(
    BuildContext context, {
    IconData? icon, // Ahora opcional
    String? svgAsset, // Nuevo: SVG
    required String title,
    required String route,
    bool isSelected = false,
    bool isGroupItem = false,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final double iconSize = isGroupItem ? 20 : 24;
    final Color iconColor = isSelected
        ? theme.colorScheme.primary
        : colors.sidebarGradient1.computeLuminance() < 0.4
        ? theme.colorScheme.onSecondary.withAlpha(140)
        : colors.textDefault.withAlpha(170);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(50)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: isGroupItem ? 16 : 8,
        vertical: 2,
      ),
      child: ListTile(
        leading: svgAsset != null
            ? SvgPicture.asset(
                svgAsset,
                width: iconSize,
                height: iconSize,
                color: iconColor,
              )
            : Icon(icon, color: iconColor, size: iconSize),
        title: Text(
          title,
          style: TextStyle(
            color: iconColor,
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
        onTap: () => _navigateToRoute(context, route),
      ),
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - LÓGICA DE NAVEGACIÓN Y ACCIONES
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _navigateToRoute()
  ///
  /// Maneja la navegación a una ruta, cerrando el drawer en mobile si es necesario.
  ///
  /// Parameters:
  /// - `context`: Contexto de build
  /// - `route`: Ruta de destino
  /// --------------------------------------------------------------------------
  void _navigateToRoute(BuildContext context, String route) {
    // Cierra drawer en mobile
    if (MediaQuery.of(context).size.width <= _desktopBreakpoint) {
      Navigator.of(context).pop();
    }
    // Navega a la ruta
    context.go(route);
  }

  /// --------------------------------------------------------------------------
  /// # _handleMenuAction()
  ///
  /// Maneja las acciones del menú de usuario.
  ///
  /// Parameters:
  /// - `action`: Acción seleccionada
  /// --------------------------------------------------------------------------
  void _handleMenuAction(String action) {
    switch (action) {
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - DIÁLOGO DE LOGOUT
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _showLogoutDialog()
  ///
  /// Muestra el diálogo de confirmación de logout.
  /// --------------------------------------------------------------------------
  void _showLogoutDialog() {
    final colors = Theme.of(context).extension<AppColors>()!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_Texts.logoutTitle),
        content: const Text(_Texts.logoutMessage),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCancelButton(colors),
              const SizedBox(width: 20),
              _buildLogoutButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildCancelButton()
  ///
  /// Construye el botón de cancelar del diálogo de logout.
  ///
  /// Parameters:
  /// - `colors`: Extensiones de colores del tema
  ///
  /// Returns:
  /// - `TextButton` configurado para cancelar
  /// --------------------------------------------------------------------------
  Widget _buildCancelButton(AppColors colors) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(foregroundColor: colors.cancelTextButton),
      child: const Text(_Texts.cancel),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildLogoutButton()
  ///
  /// Construye el botón de confirmación de logout.
  ///
  /// Returns:
  /// - `ElevatedButton` configurado para logout
  /// --------------------------------------------------------------------------
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        ref.read(authProvider.notifier).logout();
        context.go('/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text(_Texts.logoutConfirm),
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - UTILIDADES
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # _calculateIsDark()
  ///
  /// Calcula si el tema actual es oscuro.
  ///
  /// Parameters:
  /// - `themeMode`: Modo de tema actual
  /// - `context`: Contexto de build
  ///
  /// Returns:
  /// - `bool` indicando si el tema es oscuro
  /// --------------------------------------------------------------------------
  bool _calculateIsDark(ThemeMode themeMode, BuildContext context) {
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }
}

// =============================================================================
// _Texts - Clase para centralizar textos
// =============================================================================
// MEJORA: Centralización de todos los textos para:
// - Mayor mantenibilidad
// - Facilitar internacionalización
// - Consistencia en la UI
// =============================================================================
class _Texts {
  // Temas
  static const themeSystem = 'Seguir tema del sistema';
  static const themeLight = 'Claro';
  static const themeDark = 'Oscuro';

  // Navegación - Grupos
  static const groupFarm = 'Finca';
  static const groupAnimals = 'Animales';

  // Navegación - Items de menú
  static const menuHome = 'Inicio';
  static const menuLots = 'Lotes';
  static const menuPaddocks = 'Corrales';
  static const menuBreeds = 'Razas';
  static const menuAnimals = 'Animales';
  static const menuMilkings = 'Ordeños';

  // Usuario y Logout
  static const logout = 'Cerrar Sesión';
  static const logoutTitle = 'Cerrar Sesión';
  static const logoutMessage = '¿Estás seguro que quieres cerrar sesión?';
  static const logoutConfirm = 'Cerrar Sesión';
  static const cancel = 'Cancelar';

  // Información general
  static const version = 'Versión 1.0.0';
}
