import 'package:very_good_slide_puzzle/models/explorer.dart';
import 'package:very_good_slide_puzzle/models/puzzle_tsuro.dart';
import 'package:very_good_slide_puzzle/tiles/tile_constants.dart';

/// List of puzzle levels

var levels =  [
  Puzzle(
      puzzleNumber: 1,
      tiles: [TILE_1, TILE_2, TILE_3, TILE_4, TILE_5, TILE_6, TILE_7, TILE_8, WHITESPACE],
      explorer: Explorer(currentTile: TILE_3, currentPath: 6),
      maxNumberOfMoves: 5,
  ),
];

