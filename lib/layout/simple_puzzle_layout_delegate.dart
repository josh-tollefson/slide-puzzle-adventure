import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/theme/widgets/level_and_moves_left.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        if (state.puzzleStatus != PuzzleStatus.complete) ...[
          ResponsiveLayoutBuilder(
            small: (_, child) => const SimpleMoveExplorerButton(),
            medium: (_, child) => const SimpleMoveExplorerButton(),
            large: (_, __) => const SizedBox(),
          ),
          ResponsiveLayoutBuilder(
            small: (_, child) => const SimpleReverseExplorerDirectionButton(),
            medium: (_, child) => const SimpleReverseExplorerDirectionButton(),
            large: (_, __) => const SizedBox(),
          ),
          ResponsiveLayoutBuilder(
            small: (_, child) => const SimplePuzzleResetButton(),
            medium: (_, child) => const SimplePuzzleResetButton(),
            large: (_, __) => const SizedBox(),
          ),
        ]
        else ...[
          ResponsiveLayoutBuilder(
            small: (_, child) => const SimpleNextLevelButton(),
            medium: (_, child) => const SimpleNextLevelButton(),
            large: (_, __) => const SizedBox(),
          ),
        ],
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
            status: state.puzzleStatus,
            offBoard: state.puzzle.explorer.offBoard,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        LevelAndMovesLeft(
          level: state.puzzle.puzzleNumber,
          remainingNumberOfMoves: state.remainingNumberOfMoves,
          maxNumberOfMoves: state.puzzle.maxNumberOfMoves,
        ),
        const ResponsiveGap(large: 32),
        if (state.puzzleStatus == PuzzleStatus.complete) ...[
          ResponsiveLayoutBuilder(
            small: (_, __) => const SizedBox(),
            medium: (_, __) => const SizedBox(),
            large: (_, __) => const SimpleNextLevelButton(),
          ),
        ]
        else ...[
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimpleMoveExplorerButton(),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleResetButton(),
        ),
      ],
    ]
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
    required this.offBoard,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;
  final bool offBoard;

  @override
  Widget build(BuildContext context) {
    String getPuzzleTitle(PuzzleStatus status) {
      if (status == PuzzleStatus.complete) {
        return context.l10n.puzzleCompleted;
      }
      else if (offBoard) {
        return context.l10n.puzzleOffBoard;
      }
      else if (status == PuzzleStatus.lost) {
        return context.l10n.puzzleLost;
      }
      else {
        return context.l10n.puzzleChallengeTitle;
      }
    }

    return PuzzleTitle(
      title: getPuzzleTitle(status),
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: 0, //spacing,
      crossAxisSpacing: 0, //spacing,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

// class AnimatedPuzzleTile extends StatefulWidget {
//   _AnimatedPuzzleTileState createState() => _AnimatedPuzzleTileState();
// }
//
// class _AnimatedPuzzleTileState extends State<AnimatedPuzzleTile> {
//   late double tileFontSize;
//
//   @override
//   void initState() {
//     super.initState();
//     tileFontSize = 0;
//   }
//
//   void changeTile() {
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               width: 128,
//               height: 128,
//               child: AnimatedContainer(
//                 margin: EdgeInsets.all(margin),
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(borderRadius),
//                 ),
//                 duration: _duration,
//               ),
//             ),
//             ElevatedButton(
//               child: Text('change'),
//               onPressed: () => change(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// }
//
//
/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
class SimplePuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTile();
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class _SimplePuzzleTile extends State<SimplePuzzleTile> {

  bool isHovering = false;

  Alignment _explorerAlignment(Explorer explorer) {
    switch (explorer.currentPath) {
      case 0:
        return Alignment(-0.5, -1.1);
      case 1:
        return Alignment(0.5, -1.1);
      case 2:
        return Alignment(1.1, -0.5);
      case 3:
        return Alignment(1.1, 0.5);
      case 4:
        return Alignment(0.5, 1.1);
      case 5:
        return Alignment(-0.5, 1.1);
      case 6:
        return Alignment(-1.1, 0.5);
      case 7:
        return Alignment(-1.1, -0.5);
      default:
        return Alignment(0, 0);
    }
  }

  Alignment _destinationAlignment(Explorer explorer) {
    switch (explorer.destinationPath) {
      case 0:
        return Alignment(-0.5, -1.0);
      case 1:
        return Alignment(0.5, -1.0);
      case 2:
        return Alignment(1.0, -0.5);
      case 3:
        return Alignment(1.0, 0.5);
      case 4:
        return Alignment(0.5, 1.0);
      case 5:
        return Alignment(-0.5, 1.0);
      case 6:
        return Alignment(-1.0, 0.5);
      case 7:
        return Alignment(-1.0, -0.5);
      default:
        return Alignment(0, 0);
    }
  }

  Alignment _arrowAlignment(Explorer explorer) {
    switch (explorer.currentPath) {
      case 0:
        return Alignment(-0.5, -0.5);
      case 1:
        return Alignment(0.5, -0.5);
      case 2:
        return Alignment(0.5, -0.5);
      case 3:
        return Alignment(0.5, 0.5);
      case 4:
        return Alignment(0.5, 0.5);
      case 5:
        return Alignment(-0.5, 0.5);
      case 6:
        return Alignment(-0.5, 0.5);
      case 7:
        return Alignment(-0.5, -0.5);
      default:
        return Alignment(0, 0);
    }
  }

  double _arrowRotation(Explorer explorer)  {
    /// direction the explorer is facing
    final directionality = explorer.forwardDirection ? 1 : -1;

    switch (explorer.currentPath) {
      case 0:
        return pi / 180 * 90 * directionality;
      case 1:
        return pi / 180 * 90 * directionality;
      case 2:
        return pi / 180 * (90 + 90 * directionality);
      case 3:
        return pi / 180 * (90 + 90 * directionality);
      case 4:
        return pi / 180 * -90 * directionality;
      case 5:
        return pi / 180 * -90 * directionality;
      case 6:
        return pi / 180 * (90 - 90 * directionality);
      case 7:
        return pi / 180 * (90 - 90 * directionality);
      default:
        return 0;
    }
  }

  Widget _showDash(BuildContext context) {
    return Container(
      alignment:
          _explorerAlignment(context.read<PuzzleBloc>().state.puzzle.explorer),
      child: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset(
          '../assets/images/simple_dash_small.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _showDestination(BuildContext context) {
    return Container(
      alignment:
      _destinationAlignment(context.read<PuzzleBloc>().state.puzzle.explorer),
      child: SizedBox(
        width: 90,
        height: 90,
        child: Image.asset(
          '../assets/images/scenery/trees_1.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _showArrow(BuildContext context) {
    return Container(
      alignment: _arrowAlignment(context.read<PuzzleBloc>().state.puzzle.explorer),
      child: Transform.rotate(
        angle: _arrowRotation(context.read<PuzzleBloc>().state.puzzle.explorer),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            '../assets/images/arrow.png',
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return MouseRegion(
        onEnter: (PointerEvent details) => setState(() => isHovering = true),
        onExit: (PointerEvent details) => setState(() => isHovering = false),
        child: GestureDetector(
          onTap: () => context.read<PuzzleBloc>().add(TileTapped(widget.tile)),
          child: Stack(children: [
            // TODO: We shouldn't need to specify SizedBox, layout is a bit janky right now.
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(
                '../assets/images/scenery/${widget.tile.image}',
                fit: BoxFit.cover,
              ),
            ),
            if (context.read<PuzzleBloc>().state.puzzle.explorer.destinationTile.value ==
                widget.tile.value)
              _showDestination(context),
            if (context.read<PuzzleBloc>().state.puzzle.explorer.currentTile ==
                widget.tile)
              _showDash(context),
            if (context.read<PuzzleBloc>().state.puzzle.explorer.currentTile ==
                widget.tile)
              _showArrow(context),
            if (isHovering)
              Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        )
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to reset the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleResetButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleReset),
        ],
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to move the explorer.
/// {@endtemplate}
@visibleForTesting
class SimpleMoveExplorerButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimpleMoveExplorerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const ExplorerMoved()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleMoveExplorer),
        ],
      ),
    );
  }
}


/// {@template puzzle_shuffle_button}
/// Displays the button to reverse the explorer's direction.
/// {@endtemplate}
@visibleForTesting
class SimpleReverseExplorerDirectionButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimpleReverseExplorerDirectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const ExplorerReversed()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleReverseExplorer),
        ],
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to advance to next level.
/// {@endtemplate}
@visibleForTesting
class SimpleNextLevelButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimpleNextLevelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const NextLevel()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleNextLevel),
        ],
      ),
    );
  }
}
