import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final EmpDashboardProvider provider;

  CustomNavigatorObserver(this.provider);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Aquí verificamos la ruta anterior (cuando el usuario vuelve atrás)
    if (previousRoute?.settings.name != null) {
      String previousPath = previousRoute!.settings.name!;
      provider.updateIndexFromUrl(previousPath);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    // Actualizamos el índice cuando se navega a una nueva ruta
    if (route.settings.name != null) {
      String currentPath = route.settings.name!;
      provider.updateIndexFromUrl(currentPath);
    }
  }
}
