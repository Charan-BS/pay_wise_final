import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../../../constants/constants.dart';

class InviteSection extends StatelessWidget {
  const InviteSection({super.key});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.3,
          decoration: const BoxDecoration(color: tWhiteColor),
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Invite your client/freelancer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.6))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Seamless Transactions, Infinite Possibilities.',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.4)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1, color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: OutlinedButton(
                        onPressed: () => Share.share(tFullMessage),
                        child: Center(
                          child: Text('Invite', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
