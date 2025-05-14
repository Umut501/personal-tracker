import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/dashboard_screen.dart';
import 'screens/movement_screen.dart';
import 'screens/food_screen.dart';
import 'screens/water_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/writing_screen.dart';
import 'screens/studying_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/analytics_screen.dart';
import 'providers/activity_provider.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: MaterialApp(
        title: 'Kişisel Takip',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'),
        ],
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _screens = [
    {
      'title': 'Özet',
      'icon': Icons.dashboard,
      'screen': const DashboardScreen(),
    },
    {
      'title': 'Hareket',
      'icon': Icons.directions_walk,
      'screen': const MovementScreen(),
    },
    {
      'title': 'Beslenme',
      'icon': Icons.fastfood,
      'screen': const FoodScreen(),
    },
    {
      'title': 'Su',
      'icon': Icons.water_drop,
      'screen': const WaterScreen(),
    },
    {
      'title': 'Harcama',
      'icon': Icons.shopping_cart,
      'screen': const ExpenseScreen(),
    },
    {
      'title': 'Okuma',
      'icon': Icons.book,
      'screen': const ReadingScreen(),
    },
    {
      'title': 'Yazma',
      'icon': Icons.edit,
      'screen': const WritingScreen(),
    },
    {
      'title': 'Ders',
      'icon': Icons.school,
      'screen': const StudyingScreen(),
    },
    {
      'title': 'Takvim',
      'icon': Icons.calendar_today,
      'screen': const CalendarScreen(),
    },
    {
      'title': 'Analiz',
      'icon': Icons.bar_chart,
      'screen': const AnalyticsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex]['title']),
        elevation: 2,
      ),
      body: _screens[_selectedIndex]['screen'],
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kişisel Takip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sağlıklı yaşam için günlük takip',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ..._screens.asMap().entries.map((entry) {
            final index = entry.key;
            final screen = entry.value;
            return ListTile(
              leading: Icon(
                screen['icon'],
                color: _selectedIndex == index ? AppColors.primary : null,
              ),
              title: Text(
                screen['title'],
                style: TextStyle(
                  color: _selectedIndex == index ? AppColors.primary : null,
                  fontWeight: _selectedIndex == index ? FontWeight.bold : null,
                ),
              ),
              selected: _selectedIndex == index,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex < 5 ? _selectedIndex : 4,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Özet',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk),
          label: 'Hareket',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          label: 'Beslenme',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Su',
        ),
        BottomNavigationBarItem(
          icon: PopupMenuButton<int>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context) {
              return [
                for (int i = 4; i < _screens.length; i++)
                  PopupMenuItem(
                    value: i,
                    child: Row(
                      children: [
                        Icon(
                          _screens[i]['icon'],
                          color: _selectedIndex == i ? AppColors.primary : null,
                        ),
                        const SizedBox(width: 8),
                        Text(_screens[i]['title']),
                      ],
                    ),
                  ),
              ];
            },
          ),
          label: 'Diğer',
        ),
      ],
    );
  }
}
