import 'package:very_good_slide_puzzle/models/explorer.dart';
import 'package:very_good_slide_puzzle/models/puzzle_tsuro.dart';
import 'package:very_good_slide_puzzle/tiles/tile_constants.dart';

/// List of puzzle levels

var levels =  [
  Puzzle(
      puzzleNumber: 1,
      tiles: [TILE_1, TILE_2, TILE_3, WHITESPACE],
      explorer: Explorer(currentTile: TILE_1, currentPath: 7),
      maxNumberOfMoves: 3,
  ),
];

