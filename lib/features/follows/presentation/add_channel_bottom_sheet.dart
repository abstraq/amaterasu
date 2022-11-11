import "package:amaterasu/features/follows/presentation/add_channel_list.dart";
import "package:flutter/material.dart";

class AddChannelBottomSheet extends StatelessWidget {
  const AddChannelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add Channel",
                style: Theme.of(context).textTheme.subtitle1,
              )),
          const Expanded(child: AddChannelList()),
        ],
      ),
    );
  }
}
