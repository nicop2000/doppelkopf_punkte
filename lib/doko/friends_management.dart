import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsManagement extends StatelessWidget {
  const FriendsManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Accountinformationen",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (context.read<AppUser>().friends.length <= 3)
                        Center(
                            child: Text("Du hast noch keine Freunde :c",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)))
                      else
                        for (Friend friend in context.read<AppUser>().friends)
                          if (friend.uid != "null") getFriend(friend, context)
                    ])),
          ],
        ),
      ),
    );
  }

  Widget getFriend(Friend friend, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          friend.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 18,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.remove_circle_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () async {
            context.read<AppUser>().removeFriend(friend.uid);
          },
        ),
      ],
    );
  }
}
