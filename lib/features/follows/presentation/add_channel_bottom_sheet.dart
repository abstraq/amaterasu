import "package:amaterasu/features/follows/presentation/add_channel_list.dart";
import "package:flutter/material.dart";

class AddChannelBottomSheet extends StatelessWidget {
  const AddChannelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(onPressed: () {}, child: const Text("Add All")),
          const Expanded(child: AddChannelList()),
        ],
      ),
    );
  }
}
