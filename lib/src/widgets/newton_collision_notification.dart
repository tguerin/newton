import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// Notification sent by [NewtonCollider] to the [Newton] root.
///
/// This notification carries the geometry information (position, size, and border radius)
/// of a widget that should act as a collision boundary for particles.
class NewtonCollisionNotification extends Notification {
  /// Creates a [NewtonCollisionNotification].
  ///
  /// - [id]: Unique identifier for this collider.
  /// - [rect]: The rectangle representing the widget's position and size in global coordinates.
  /// - [borderRadius]: The border radius of the widget, used for rounded corner collision detection.
  /// - [isRemoving]: Whether this notification is removing the collider.
  NewtonCollisionNotification({
    required this.id,
    required this.rect,
    this.borderRadius = BorderRadius.zero,
    this.isRemoving = false,
  });

  /// Unique identifier for this collider.
  final String id;

  /// The rectangle representing the widget's position and size in global coordinates.
  final Rect rect;

  /// The border radius of the widget.
  final BorderRadius borderRadius;

  /// Whether this notification is removing the collider.
  final bool isRemoving;
}
