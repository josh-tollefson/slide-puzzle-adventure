import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

/// Path on the opposite side of the tile
/// Used to get the paths of neighboring tiles
Map<int,int> oppositePath = {0:5, 1:4, 2:7, 3:6, 4:1, 5:0, 6:3, 7:2};

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}
class Tile extends Equatable {
  /// {@macro tile}
  const Tile({
    this.value = 0,
    this.startPosition = const Position(x: 0, y: 0),
    this.currentPosition = const Position(x: 0, y: 0),
    this.paths = const {},
    this.markers = const {},
    this.image = '',
    this.isWhitespace = false,
  });

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The starting 2D [Position] of the [Tile].
  final Position startPosition;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  /// Dictionary containing all paths
  /// --- 0 --- 1 ---
  /// |              |
  /// 7              2
  /// |              |
  /// 6              3
  /// |              |
  /// --- 5 --- 4 ---
  /// e.g., {0: 2} means there is path from point 0 to point 2 on the tile
  /// For now, paths are bi-directional
  final Map<int,int> paths;

  /// Dictionary containing marker locations
  /// e.g., {0: 'puzzle_start', 4: 'puzzle_end'}
  final Map<int,String> markers;

  /// name of image
  final String image;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      startPosition: startPosition,
      currentPosition: currentPosition,
      paths: paths,
      markers: markers,
      image: image,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object> get props => [
    value,
    startPosition,
    currentPosition,
    paths,
    markers,
    isWhitespace,
  ];
}
