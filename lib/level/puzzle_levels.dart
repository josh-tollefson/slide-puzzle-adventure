import 'package:very_good_slide_puzzle/models/explorer.dart';
import 'package:very_good_slide_puzzle/models/puzzle_tsuro.dart';
import 'package:very_good_slide_puzzle/tiles/tile_constants.dart';

/// List of puzzle levels

var levels =  [
  Puzzle(
    puzzleNumber: 1,
    tiles: [TILE_1, TILE_2, TILE_3, WHITESPACE],
    explorer: Explorer(
      currentTile: TILE_2,
      currentPath: 0,
      destinationTile: TILE_2,
      destinationPath: 3,
      forwardDirection: true,
    ),
    maxNumberOfMoves: 3,
  ),
  Puzzle(
    puzzleNumber: 2,
    tiles: [TILE_1, WHITESPACE, TILE_3, TILE_2],
    explorer: Explorer(
      currentTile: TILE_2,
      currentPath: 4,
      destinationTile: TILE_1,
      destinationPath: 7,
      forwardDirection: true,
    ),
    maxNumberOfMoves: 3,
  ),
  Puzzle(
      puzzleNumber: 3,
      tiles: [TILE_1, TILE_2, TILE_3, WHITESPACE],
      explorer: Explorer(
        currentTile: TILE_1,
        currentPath: 7,
        destinationTile: TILE_3,
        destinationPath: 2,
        forwardDirection: true,
      ),
      maxNumberOfMoves: 3,
  ),
];

