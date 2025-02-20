import 'package:flutter/material.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/pages/inventory/item_screen.dart';
import 'package:goldinventory/services/items.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.onReload});

  final Item item;
  final Function() onReload;

  void _onClickCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemScreen(item: item)),
    ).then(
      (value) => {
        if (value == 'completed') {onReload()}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 201, 201, 194),
        ),
      ),
      child: TextButton(
        onPressed: () => _onClickCard(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.black,
          ),
          overlayColor: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: item.image != null
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/image_placeholder.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/image_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                if (item.status != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: StatusTag(
                      text: item.status?.name ?? "",
                      backgroundColor: Color(item.status!.backgroundColor),
                      textColor: Color(item.status!.textColor),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isOverflowing = constraints.maxWidth < 200;
                      String displayText = item.name.length > 10
                          ? "${item.name.substring(0, 10)} ..."
                          : item.name;
                      return RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Nome: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: isOverflowing ? displayText : item.name,
                              style: const TextStyle(
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  if (item.location != null)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        String displayText = item.location!.name.length > 10
                            ? "${item.location!.name.substring(0, 10)} ..."
                            : item.location!.name;
                        return RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Local: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: displayText,
                                style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 4),
                  if (item.type != null)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        String displayText = item.type!.name.length > 10
                            ? "${item.type!.name.substring(0, 10)} ..."
                            : item.type!.name;
                        return RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Tipo: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: displayText,
                                style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
