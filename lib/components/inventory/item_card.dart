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
          child: LayoutBuilder(builder: (context, constraints) {
            bool isSmall = constraints.maxWidth < 160;
            double fontSize = isSmall ? 10 : 14;
            double spacing = isSmall ? 1 : 2;
            return Column(
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
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
                          isSmall: isSmall,
                          backgroundColor: Color(item.status!.backgroundColor),
                          textColor: Color(item.status!.textColor),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Nome: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: fontSize,
                              ),
                            ),
                            TextSpan(
                              text: item.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing),
                      if (item.location != null)
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Local: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: fontSize,
                                ),
                              ),
                              TextSpan(
                                text: item.location!.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontSize,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: spacing),
                      if (item.type != null)
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Tipo: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: fontSize,
                                ),
                              ),
                              TextSpan(
                                text: item.type!.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }
}
