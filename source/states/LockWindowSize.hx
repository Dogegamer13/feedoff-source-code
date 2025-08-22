package states;

import openfl.Lib;
import openfl.events.Event;

#if (hl || cpp || neko)
import lime.app.Application;
import lime.ui.Window;
#end

class LockWindowSize {
    static var lockedX:Float;
    static var lockedY:Float;
    static var initialized:Bool = false;
    static var selfAdjusting:Bool = false;

    public static function init():Void {
        #if (hl || cpp || neko)
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, onFirstFrame);
        #end
    }

    #if (hl || cpp || neko)
    static function onFirstFrame(_):Void {
        if (initialized) return;
        initialized = true;
        Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onFirstFrame);

        var win:Window = Application.current.window;

        lockedX = win.x;
        lockedY = win.y;

        try win.resizable = false catch(e:Dynamic) {};
        try win.borderless = false catch(e:Dynamic) {};

        win.onMove.add(function(x:Float, y:Float) {
            if (selfAdjusting) return;
            if (x != lockedX || y != lockedY) {
                selfAdjusting = true;
                win.move(Std.int(lockedX), Std.int(lockedY)); // ✅ cast
                selfAdjusting = false;
            }
        });
    }
    #end
}
