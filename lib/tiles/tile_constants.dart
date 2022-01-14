import 'package:very_good_slide_puzzle/models/tile_tsuro.dart';

var TILE_1 = Tile(
          value: 1,
          paths: {0:1,1:0,2:7,3:6,4:5,5:4,6:3,7:2},
          image: 'tile_1_filled.png',
);

var TILE_2 = Tile(
          value: 2,
          paths: {0:3,1:2,2:1,3:0,4:7,5:6,6:5,7:4},
          image: 'tile_2_filled.png',
);

var TILE_3 = Tile(
          value: 3,
          paths: {0:5,1:7,2:6,3:4,4:5,5:0,6:2,7:1},
          image: 'tile_3_filled.png',
);

var WHITESPACE = Tile(
          isWhitespace: true,
);




