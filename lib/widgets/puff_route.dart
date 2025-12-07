import 'package:flutter/material.dart';

class PuffRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  PuffRoute({
    required this.builder,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Overall, we want:
            // 1. Old page visible.
            // 2. White overlay fades in (opacity 0 -> 1). covering old page.
            // 3. New page (child) stays hidden or behind white.
            // 4. White overlay fades out (opacity 1 -> 0) revealing new page.
            // OR simpler:
            // 1. White background is always behind 'child'.
            // 2. 'child' Fades IN (0->1).
            // BUT that doesn't hide the OLD page unless the OLD page also Fades OUT or is covered.

            // To achieve "Old -> White -> New":
            // We can use a Stack.
            // We need a "White Curtain" that fades in and out?
            // Actually, PageRouteBuilder transitions sit ON TOP of the previous route.
            // So if we just FadeIn the new page (0->1), we see Old -> New mixing. Not "White".

            // To get "White" in between:
            // The NEW page should start as a Solid White container, then the content fades in?
            // AND we need to cover the OLD page with White first.
            // But transitionsBuilder only affects the NEW page (child). The OLD page is underneath.

            // Standard trick:
            // 1. FadeTransition (opacity 0->1) of a Container(color: White)
            //    This makes the screen turn white (covering the old page).
            //    This needs to happen in the first half (0.0 - 0.5).
            // 2. FadeTransition (opacity 0->1) of the CHILD.
            //    This needs to happen in the second half (0.5 - 1.0).
            
            // However, if we just fade in White, then the Child is still invisible?
            // Let's structure the stack:
            // Stack(
            //   children: [
            //     // The white background that covers the PREVIOUS route
            //     FadeTransition(
            //        opacity: Tween(0.0 -> 1.0) for t=0.0 to 0.5
            //        child: Container(color: Colors.white)
            //     ),
            //     // The content of the NEW route
            //     FadeTransition(
            //        opacity: Tween(0.0 -> 1.0) for t=0.5 to 1.0
            //        child: child
            //     )
            //   ]
            // )
            
            // But wait, once the white background is 1.0 (at t=0.5), it stays 1.0?
            // Yes, so at t=0.5, screen is full white.
            // Then from 0.5 to 1.0, the CHILD fades in ON TOP of the white.
            // Since the child is opaque (usually), it will cover the white.
            // That works! "Old -> (fade to white) -> White -> (fade to child) -> Child".

            final whiteOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
              ),
            );

            final childOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
              ),
            );

            return Stack(
              children: [
                // White background fading in to cover previous route
                FadeTransition(
                  opacity: whiteOpacity,
                  child: Container(color: Colors.white),
                ),
                // New page content fading in on top of white
                FadeTransition(
                  opacity: childOpacity,
                  child: child,
                ),
              ],
            );
          },
        );
}
