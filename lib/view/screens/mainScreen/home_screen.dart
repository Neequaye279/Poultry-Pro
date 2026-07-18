import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/production_category.dart';
import 'package:poultry_pro/view_model/production_provider.dart';
import 'package:poultry_pro/view_model/flock_provider.dart';
import 'package:poultry_pro/view/widgets/dashboard_header.dart';
import 'package:poultry_pro/view/widgets/stat_card.dart';
import 'package:poultry_pro/view/widgets/lowfeed_alert.dart';
import 'package:poultry_pro/view/widgets/weekly_eggs_card.dart';
import 'package:poultry_pro/view/widgets/recent_activity_card.dart';
import 'package:poultry_pro/view_model/profile_provider.dart';
import 'package:poultry_pro/view_model/dashboard_finance.dart';

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

String _currentMonthLabel() {
  const months = [
    'January',
    'Fberuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final now = DateTime.now();
  return '${months[now.month - 1]} ${now.year}';
}

String _formatNumber(int n) {
  return n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );
}

IconData _iconFor(ProductionType category) {
  switch (category) {
    case ProductionType.egg:
      return LucideIcons.egg;
    case ProductionType.feed:
      return LucideIcons.utensils;
    case ProductionType.vaccines:
      return LucideIcons.syringe;
    case ProductionType.mortality:
      return LucideIcons.skull;
  }
}

String _activityTitle(Production entry) {
  return switch (entry) {
    EggProduction() => '${entry.collected} eggs recorded',
    FeedProduction() =>
      '${entry.amountAdded.toStringAsFixed(0)} kg feed purchased',
    VaccineProduction() =>
      '${entry.vaccineName} vaccine · ${entry.dosesAdministered} doses',
    MortalityProduction() =>
      '${entry.dead} dead${entry.missing > 0 ? ' · ${entry.missing} missing' : ''}',
  };
}

String _activitySubtitle(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final entryDate = DateTime(date.year, date.month, date.day);
  final diff = today.difference(entryDate).inDays;

  if (diff == 0) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return 'Today, $hour:$minute';
  }
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '$diff days ago';
  return '${date.day}/${date.month}/${date.year}';
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productionAsync = ref.watch(productionProvider);
    final flockAsync = ref.watch(flockProvider);

    final isLoading = productionAsync.isLoading || flockAsync.isLoading;
    final hasError = productionAsync.hasError || flockAsync.hasError;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Text(
            'Failed to load dashboard: '
            '${productionAsync.error ?? flockAsync.error}',
          ),
        ),
      );
    }

    final profile = ref.watch(profileProvider).value;
    final summary = ref.watch(monthlyFinanceSummaryProvider);

    final profitMargin = summary.revenue == 0
        ? 0.0
        : (summary.netProfit / summary.revenue * 100);

    final colors = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final totalBirds = ref.watch(totalBirdsProvider);
    final activeFlocks = ref.watch(activeFlocksCountProvider);
    final todaysEggs = ref.watch(todaysEggsProvider);
    final eggsDayChange = ref.watch(eggsDayOverDayChangeProvider);
    final feedRemaining = ref.watch(latestFeedRemainingProvider);
    final daysOfFeedLeft = ref.watch(daysOfFeedRemainingProvider);
    final weeklyMortalityDead = ref.watch(weeklyMortalityDeadProvider);
    final weeklyEggs = ref.watch(weeklyEggsByDayProvider);
    final weeklyEggsTotal = ref.watch(weeklyEggsTotalProvider);
    final eggsWeekChange = ref.watch(eggsWeekOverWeekChangeProvider);
    final recentActivity = ref.watch(recentActivityProvider);
    final today = DateTime.now();
    final todayIndex = today.weekday - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DashboardHeader(
                greeting: _greeting(),
                farmName: profile?.farm,
                netProfit: "GHS ${summary.netProfit.toStringAsFixed(0)}",
                monthLabel: _currentMonthLabel(),
                profitMarginPct: profitMargin,
              ),
              SizedBox(height: screenHeight * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "TOTAL BIRDS",
                            value: _formatNumber(totalBirds),
                            stat:
                                "$activeFlocks active flock${activeFlocks == 1 ? '' : 's'}",
                            icon: LucideIcons.feather,
                            iconColor: colors.primary,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: StatCard(
                            title: "EGGS TODAY",
                            value: "$todaysEggs",
                            stat: eggsDayChange == 0
                                ? "No change vs yesterday"
                                : "${eggsDayChange >= 0 ? '↑' : '↓'} ${eggsDayChange.abs().toStringAsFixed(0)}% vs yesterday",
                            icon: LucideIcons.egg,
                            iconColor: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "FEED STOCK",
                            value: feedRemaining == null
                                ? "0 kg"
                                : "${feedRemaining.round()} kg",
                            stat: daysOfFeedLeft == null
                                ? (feedRemaining == null
                                      ? "No feed logged"
                                      : "Log again to estimate")
                                : "~${daysOfFeedLeft.round()} days left",
                            icon: LucideIcons.utensils,
                            iconColor: colors.secondary,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: StatCard(
                            title: "MORTALITY",
                            value: "$weeklyMortalityDead",
                            stat: "This week",
                            icon: LucideIcons.skull,
                            iconColor: colors.error,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (daysOfFeedLeft != null && daysOfFeedLeft <= 5)
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                        child: LowfeedAlert(
                          flockName: "Feed stock",
                          restockMessage:
                              "restock in ~${daysOfFeedLeft.round()} days",
                          onTap: () {},
                        ),
                      ),
                    WeeklyEggsCard(
                      dayLabels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                      values: weeklyEggs,
                      highlightedIndex: todayIndex,
                      totalEggs: weeklyEggsTotal,
                      percentChange: eggsWeekChange,
                      onFullReportTap: () {
                        ref
                            .read(productionCategoryProvider.notifier)
                            .setCategory(ProductionType.egg);
                        Navigator.pushNamed(context, '/production');
                      },
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
                    if (recentActivity.isEmpty)
                      Text(
                        "No activity yet",
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14.0,
                        ),
                      )
                    else
                      RecentActivityCard(
                        items: recentActivity.map((entry) {
                          return ActivityItem(
                            icon: _iconFor(categoryOf(entry)),
                            title: _activityTitle(entry),
                            subtitle: _activitySubtitle(entry.date),
                            onTap: () {
                              ref
                                  .read(productionCategoryProvider.notifier)
                                  .setCategory(categoryOf(entry));
                              Navigator.pushNamed(context, '/production');
                            },
                          );
                        }).toList(),
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
