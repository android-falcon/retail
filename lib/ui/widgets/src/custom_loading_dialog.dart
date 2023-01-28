//packages
import 'package:flutter/material.dart';

//General loading widget to use anywhere in the app
class CustomLoadingDialog extends StatelessWidget {
  final String title;

  const CustomLoadingDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 250,
            maxWidth: 250,
          ),
          height: 0.1 * deviceSize.height,
          width: 0.8 * deviceSize.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[600],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const CircularProgressIndicator(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
