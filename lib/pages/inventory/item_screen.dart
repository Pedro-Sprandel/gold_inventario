import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/inventory/change_status_item_screen.dart';
import 'package:goldinventory/pages/inventory/edit_item_screen.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:goldinventory/utils/timestamp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Map<String, String> translateItemFields = {
  "name": "Nome",
  "code": "Código",
  "status": "Status",
  "location": "Localidade",
  "image": "Imagem",
  "type": "Tipo"
};

String getActivityText(Activity activity) {
  String text = "";

  if (activity.action == 'create') {
    text =
        "${getFormattedDate(activity.timestamp)}: Criado por ${activity.performedBy}";
  } else if (activity.action == 'update') {
    text =
        "${getFormattedDate(activity.timestamp)}: Atualizado por ${activity.performedBy}. ${activity.details!.entries.map((e) {
      if (e.key == 'image') return 'Imagem -> Imagem';

      bool isInstance =
          e.key == 'type' || e.key == 'location' || e.key == 'status';

      String oldValue = e.value['old'] == null
          ? ""
          : isInstance
              ? e.value['old']['name']
              : e.value['old'] ?? "";
      String newValue = e.value['new'] == null
          ? ""
          : isInstance
              ? e.value['new']['name']
              : e.value['new'];

      return '${translateItemFields[e.key]}: ${oldValue.isEmpty ? "\"\"" : oldValue} -> $newValue';
    }).join(', ')}";
  }

  if (activity.observation != null) {
    text += ', Obs: ${activity.observation}';
  }

  return text;
}

class ItemScreen extends StatefulWidget {
  const ItemScreen({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<ItemScreen> createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  void _onPressEdit(BuildContext context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditItemScreen(item: item)))
        .then(
      (value) async {
        if (value.runtimeType == Item) {
          setState(() {
            item = value;
          });
        }
      },
    );
  }

  void _onPressChangeStatus(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeStatusItemScreen(item: item))).then(
      (value) async {
        if (value.runtimeType == Item) {
          setState(() {
            item = value;
          });
        }
      },
    );
  }

  void _onDeleteItem(BuildContext context) async {
    Response response = await deleteItem(item.id!);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    Navigator.pop(context);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              const Text('Você tem certeza de que deseja excluir este item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _onDeleteItem(context);
              },
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
              child: BackButtonTopBar(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: item.image != null && item.image!.isNotEmpty
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/image_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.status != null)
                        StatusTag(
                          text: item.status!.name,
                          backgroundColor: Color(item.status!.backgroundColor),
                          textColor: Color(item.status!.textColor),
                        ),
                      if (userProvider.canEdit())
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => _onPressEdit(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                ),
                                child: const Row(
                                  children: [
                                    Text('Editar',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(width: 8),
                                    FaIcon(FontAwesomeIcons.pen,
                                        color: Colors.white, size: 12),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  showDeleteConfirmationDialog(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.redAccent,
                                ),
                                child: const Row(
                                  children: [
                                    Text('Deletar',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(width: 8),
                                    FaIcon(FontAwesomeIcons.trash,
                                        color: Colors.white, size: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (userProvider.canChangeStatus())
                        TextButton(
                          onPressed: () => _onPressChangeStatus(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                            child: const Row(
                              children: [
                                Text('Alterar status',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 8),
                                FaIcon(FontAwesomeIcons.pen,
                                    color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Nome: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: item.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Código: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: item.code,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (item.location != null)
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Localidade: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.location?.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      if (item.type != null)
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Tipo: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.type?.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      const Row(
                        children: [
                          Text('Relatório de atividades',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                          SizedBox(width: 8),
                          FaIcon(FontAwesomeIcons.clock),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...item.activityHistory.reversed.map(
                            (e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getActivityText(e)),
                                const SizedBox(height: 8),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
