package se.isotop.cliffpusher;

import se.isotop.cliffpusher.enums.PlayerColor;

class PlayerColors {
    public static inline var COLOR_COUNT:Int = 5;

    private static inline var PINK = 0;
    private static inline var GREEN = 1;
    private static inline var BLUE = 2;
    private static inline var RED = 3;
    private static inline var ORANGE = 4;

    public static function toInt(c:PlayerColor):Int {
        return switch ( c ) {
            case PlayerColor.Pink: PINK;
            case PlayerColor.Green: GREEN;
            case PlayerColor.Blue: BLUE;
            case PlayerColor.Red: RED;
            case PlayerColor.Orange: ORANGE;
        }
    }

    public static function toColor(c:Int):PlayerColor {
        return switch ( c ) {
            case PINK: PlayerColor.Pink;
            case GREEN: PlayerColor.Green;
            case BLUE: PlayerColor.Blue;
            case RED:  PlayerColor.Red;
            case ORANGE: PlayerColor.Orange;
            default: PlayerColor.Pink;
        }
    }

    public static function getAllColors():Array<PlayerColor> {
        var colors = new Array<PlayerColor>();
        colors.push(PlayerColor.Pink);
        colors.push(PlayerColor.Green);
        colors.push(PlayerColor.Blue);
        colors.push(PlayerColor.Red);
        colors.push(PlayerColor.Orange);

        return colors;
    }
}