import 'package:flutter/material.dart';
import 'package:poultry_pro/view/widgets/dashboard_header.dart';
import 'package:poultry_pro/view/widgets/stat_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/lowfeed_alert.dart';
import 'package:poultry_pro/view/widgets/weekly_eggs_card.dart';
import 'package:poultry_pro/view/widgets/recent_activity_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final int daysUntilOut = 4;
    final colors = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Full-bleed header, no outer padding applied
              DashboardHeader(
                farmName: "Sunrise Poultry Farm",
                netProfit: "GHS 4,820",
                percentChange: 4,
                monthLabel: "June 2026",
              ),
              SizedBox(height: screenHeight * 0.025),
              // Everything below gets consistent page padding
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                          title: "TOTAL BIRDS",
                          value: "1,240",
                          stat: "4 active flocks",
                          icon: LucideIcons.feather,
                          iconColor: colors.primary,
                        ),
                        StatCard(
                          title: "EGGS TODAY",
                          value: "318",
                          stat: "4% vs yesterday",
                          icon: LucideIcons.egg,
                          iconColor: colors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                          title: "FEED STOCK",
                          value: "420 kg",
                          stat: "12 days left",
                          icon: LucideIcons.utensils,
                          iconColor: colors.secondary,
                        ),
                        StatCard(
                          title: "MORTALITY",
                          value: "3",
                          stat: "This week",
                          icon: LucideIcons.skull,
                          iconColor: colors.error,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    LowfeedAlert(
                      flockName: "Broiler Flock A",
                      restockMessage: "restock in $daysUntilOut days.",
                      onTap: () {},
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    WeeklyEggsCard(
                      dayLabels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                      values: const [180, 260, 220, 270, 230, 320, 200],
                      highlightedIndex: 5,
                      totalEggs: 1908,
                      percentChange: 8,
                      onFullReportTap: () {},
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      "Recent",
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    RecentActivityCard(
                      items: [
                        ActivityItem(
                          icon: LucideIcons.egg,
                          title: "318 eggs recorded",
                          subtitle: "Today, 7:12 AM",
                          onTap: () {},
                        ),
                        ActivityItem(
                          icon: LucideIcons.syringe,
                          title: "Newcastle vaccine — Flock B",
                          subtitle: "Yesterday",
                          onTap: () {},
                        ),
                        ActivityItem(
                          icon: LucideIcons.utensils,
                          title: "50 kg feed purchased",
                          subtitle: "Yesterday",
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.012),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
