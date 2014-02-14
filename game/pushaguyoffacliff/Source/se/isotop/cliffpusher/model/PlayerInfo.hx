package se.isotop.cliffpusher.model;

import com.haxepunk.HXP;
import se.isotop.cliffpusher.enums.PlayerColor;

class PlayerInfo {
    private var _color:PlayerColor;

    public var id:Int;
    public var name:String;

    public var color(get_color, null):Int;
    function get_color():Int {
        return PlayerColors.toInt(_color);
    }

    public function new(id:Int) {
        this.id = id;
        _color = getColor();
        trace('new player ' + _color);
        this.name = Std.string(_color) + " Player";
    }

    private function getColor():PlayerColor {
        var currentPlayers = PlayerModel.instance.getAllPlayers();

        for(color in PlayerColors.getAllColors()) {
            if (isAvailableColor(color))
                return color;
        }

        var rndColor = HXP.rand(PlayerColors.COLOR_COUNT);

        return PlayerColors.toColor(rndColor);
    }

    private function isAvailableColor(c:PlayerColor):Bool {
        for (player in PlayerModel.instance.getAllPlayers()) {
            if (player.color == PlayerColors.toInt(c)) {
                return false;
            }
        }
        return true;
    }
}