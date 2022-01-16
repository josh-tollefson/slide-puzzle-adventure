import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

// A 3x3 puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template puzzle}
/// Model for a puzzle.
/// {@endtemplate}
class Puzzle extends Equatable {
  /// {@macro puzzle}
  const Puzzle({
    this.puzzleNumber = 0,
    required this.tiles,
    required this.explorer,
    this.maxNumberOfMoves = 0,
  });

  /// puzzle number
  final int puzzleNumber;

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<Tile> tiles;

  /// References the explorer who must reach the end of the puzzle.
  final Explorer explorer;

  /// maximum number of moves to solve the puzzle
  final int maxNumberOfMoves;

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  /// Get the single whitespace tile object in the puzzle.
  Tile getWhitespaceTile() {
    return tiles.singleWhere((tile) => tile.isWhitespace);
  }

  /// Determines if the puzzle is completed.
  bool isComplete() {
    return false; //(tiles.length - 1) - getNumberOfCorrectTiles() == 0;
  }

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }
    return true;
  }


  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
            (tile) =>
        tile.currentPosition.x == shiftPointX &&
            tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(List<Tile> tilesToSwap) {

    var newExplorer = explorer;

    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );

      if (explorer.currentTile.value == tile.value) {
        newExplorer = Explorer(
          currentTile: tiles[tileIndex],
          currentPath: explorer.currentPath,
          offBoard: explorer.offBoard,
        );
      }
    }

    return Puzzle(
        puzzleNumber: puzzleNumber,
        tiles: tiles,
        explorer: newExplorer,
        maxNumberOfMoves: maxNumberOfMoves,
    );
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    return Puzzle(
        puzzleNumber: puzzleNumber,
        tiles: sortedTiles,
        explorer: explorer,
        maxNumberOfMoves: maxNumberOfMoves,
    );
  }

  /// Move the explorer until it reaches
  /// the edge of the puzzle or the whitespace tile.
  Puzzle moveExplorer() {

    var updatedTile = explorer.currentTile;
    var updatedPath = explorer.nextPath;

    while (true) {

      // print(updatedTile);
      final neighborTile = nextTile(updatedTile, updatedPath);
      print(neighborTile);

      // if there is no neighbor tile, the explorer has reached the edge
      // of the puzzle, and 'fallen off'.
      if (neighborTile == null) {

        final newExplorer = Explorer(
          currentTile: updatedTile,
          currentPath: updatedPath,
          offBoard: true,
        );

        return Puzzle(
            puzzleNumber: puzzleNumber,
            tiles: tiles,
            explorer: newExplorer,
            maxNumberOfMoves: maxNumberOfMoves,
        );
      }

      // if the explorer reaches the whitespace tile,
      // stop at the end of the path
      else if (neighborTile.isWhitespace == true) {

        // print('HI ${updatedTile}');
        // print('HI ${updatedPath}');

        final newExplorer = Explorer(
          currentTile: updatedTile,
          currentPath: updatedPath,
        );

        return Puzzle(
          puzzleNumber: puzzleNumber,
          tiles: tiles,
          explorer: newExplorer,
          maxNumberOfMoves: maxNumberOfMoves,
        );

      }

      // otherwise, the explorer's journey continues onto the neighbor tile.
      // Correct the updated path to match the neighbor's.
      else {
        updatedTile = neighborTile;
        updatedPath = neighborTile.paths[oppositePath[updatedPath]] ?? updatedPath;
      }
    }
  }

  /// Get the next tile if the explorer follows the next path
  Tile? nextTile(Tile currentTile, int nextPath) {
    final size = getDimension();

    if ({0, 1}.contains(nextPath)) {
      if (currentTile.currentPosition.y - 1 > 0) {
        return tiles.singleWhere(
                (tile) =>
            (tile.currentPosition.x == currentTile.currentPosition.x) &
            (tile.currentPosition.y == currentTile.currentPosition.y - 1)
        );
      }
      else {
        return null;
      }
    }
    else if ({2, 3}.contains(nextPath)) {
      if (currentTile.currentPosition.x + 1 <= size) {
        return tiles.singleWhere(
                (tile) =>
            (tile.currentPosition.x == currentTile.currentPosition.x + 1) &
            (tile.currentPosition.y == currentTile.currentPosition.y)
        );
      }
      else {
        return null;
      }
    }
    else if ({4, 5}.contains(nextPath)) {
      if (currentTile.currentPosition.y + 1 <= size) {
        return tiles.singleWhere(
                (tile) =>
            (tile.currentPosition.x == currentTile.currentPosition.x) &
            (tile.currentPosition.y == currentTile.currentPosition.y + 1)
        );
      }
      else {
        return null;
      }
    }
    else if ({6, 7}.contains(nextPath)) {
      if (currentTile.currentPosition.x - 1 < 0) {
        return tiles.singleWhere(
                (tile) =>
            (tile.currentPosition.x == currentTile.currentPosition.x - 1) &
            (tile.currentPosition.y == currentTile.currentPosition.y)
        );
      }
      else {
        return null;
      }
    }
  }

  @override
  List<Object> get props => [
    tiles,
    explorer,
  ];
}
