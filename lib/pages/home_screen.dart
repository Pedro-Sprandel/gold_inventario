import 'package:flutter/material.dart';
import 'package:goldinventory/components/inventory/inventory_list.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/config_screen.dart';
import 'package:goldinventory/pages/inventory/item_screen.dart';
import 'package:goldinventory/pages/inventory/sign_new_item_screen.dart';
import 'package:goldinventory/pages/inventory_screen.dart';
import 'package:goldinventory/pages/profile_screen.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // Importando flutter_barcode_scanner

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  late final List<Widget> _pages;

  final GlobalKey<InventoryListState> _inventoryListKey =
      GlobalKey<InventoryListState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onClickAddItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignNewItemScreen(),
      ),
    ).then(
      (value) => {
        if (value == 'completed')
          {_inventoryListKey.currentState?.loadInventory()}
      },
    );
  }

  void _onClickScanQrcode(BuildContext context) async {
    try {
      String qrValue = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.QR,
      );

      if (qrValue != '-1') {
        Response response = await getItemByCode(qrValue);
        if (!response.success && context.mounted) {
          return showSnackbar(context, false, response.message);
        } else if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemScreen(item: response.data as Item),
            ),
          );
        }
      } else {
        if (context.mounted) {
          showSnackbar(context, false, 'Erro ao escanear QRCode');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context, false, 'Erro ao escanear QRCode');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const Profile(),
      Inventory(listKey: _inventoryListKey),
      const Config()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: TextButton(
                    onPressed: () => _onClickScanQrcode(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                  ),
                ),
                userProvider.canCreate()
                    ? TextButton(
                        onPressed: () => _onClickAddItem(context),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Cadastrar novo item',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                              size: 16,
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.only(top: 12),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          onTap: _onItemTapped,
          selectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.normal, height: 2),
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          selectedItemColor: Theme.of(context).colorScheme.tertiary,
          iconSize: 18,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidUser),
              label: 'Perfil',
              tooltip: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.box),
              label: 'Inventário',
              tooltip: 'Inventário',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.gear),
              label: 'Configurações',
              tooltip: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
