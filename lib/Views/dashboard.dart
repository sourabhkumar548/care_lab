import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/uiHelper.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Row(
        children: [
          // Sidebar
          UiHelper.custsidebar(container: "1",context: context),

          // Main Content
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lab Info
                        UiHelper.CustTopBar(title: "Care Diagnostics Centre"),
                        const SizedBox(height: 20),

                        // Account Information Cards
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            UiHelper.infoCard("Today’s Patient", "27", Colors.blue, Icons.people),
                            UiHelper.infoCard("Today’s Revenue", "₹14760", Colors.red, Icons.wallet),
                            UiHelper.infoCard("Patient in November", "820", Colors.green, Icons.event),
                            UiHelper.infoCard("Revenue in November", "₹520830", Colors.orange, Icons.currency_rupee),
                            UiHelper.infoCard("Patient in 2025", "9463", Colors.blue, Icons.people_alt),
                            UiHelper.infoCard("Revenue in 2025", "₹54,19,822",Colors.red, Icons.wallet),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Container(
                          width: Adaptive.w(90),
                          height: 300,
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                width: Adaptive.w(45),
                                height: 300,
                                child: UiHelper.Custcard(title: "Today's Patient", child: Container()),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: Adaptive.w(45),
                                height: 300,
                                child: UiHelper.Custcard(title: "Download Reports", child: Container()),
                              ),
                            )
                          ],),
                        ),

                        Container(
                          width: Adaptive.w(90),
                          height: 300,
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  child: UiHelper.Custcard(title: "Today's Revenue Details", child: Container())),
                            ),
                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  child: UiHelper.Custcard(title: "Staff Details", child: Container())),
                            )
                          ],),
                        )


                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
