package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

import states.FreeplayState.SongMetadata;
using StringTools;

class SongSearchState extends MusicBeatState
{
    public static var chosenSong:String = null; // song selected for Freeplay

    public var allSongs:Array<SongMetadata> = [];
    public var songs:Array<SongMetadata> = [];
    public var grpSongs:FlxGroup;

    public var curSelected:Int = 0;

    public var query:String = "";
    public var isTyping:Bool = true;
    public var caretOn:Bool = true;
    public var caretTimer:FlxTimer;

    public var searchBg:FlxSprite;
    public var searchText:FlxText;

    override public function create()
    {
        super.create();

        // ======= HARD-CODED SONG LIST =======
        allSongs = [
            new SongMetadata("Dad Battle", 0, "boyfriend", 0xFFFFFF),
            new SongMetadata("Spooky", 1, "bf", 0xFF0000),
            new SongMetadata("Bambino", 2, "bf", 0x00FF00)
            // add more songs here
        ];
        songs = allSongs.copy();

        // background
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        // search box
        searchBg = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.7), 40, FlxColor.fromRGB(30,30,40));
        searchBg.x = (FlxG.width - searchBg.width) / 2;
        searchBg.y = 20;
        add(searchBg);

        searchText = new FlxText(searchBg.x + 10, searchBg.y + 10, searchBg.width - 20, "Type to search…");
        searchText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, "left");
        add(searchText);

        // song list
        grpSongs = new FlxGroup();
        add(grpSongs);
        rebuildSongItems();

        // caret blinking
        caretTimer = new FlxTimer().start(0.5, function(t) caretOn = !caretOn, 0);
    }

    // ========================
    // === UPDATE LOOP ========
    // ========================
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        handleTyping();

        if (!isTyping)
        {
            if (FlxG.keys.justPressed.UP) changeSelection(-1);
            if (FlxG.keys.justPressed.DOWN) changeSelection(1);

            if (FlxG.keys.justPressed.ENTER)
            {
                // store selected song in static variable
                chosenSong = songs[curSelected].songName;
                MusicBeatState.switchState(new FreeplayState());
            }

            if (FlxG.keys.justPressed.ESCAPE)
            {
                MusicBeatState.switchState(new FreeplayState());
            }
        }

        updateSearchText();
    }

    // ========================
    // === SONG LIST BUILD =====
    // ========================
    function rebuildSongItems()
    {
        if (grpSongs != null) grpSongs.clear();

        for (i in 0...songs.length)
        {
            var md = songs[i];
            var txt = new FlxText(0, 100 + (i * 40), FlxG.width, md.songName);
            txt.setFormat(null, 24, FlxColor.WHITE, "center");
            grpSongs.add(txt);
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);

        for (i in 0...grpSongs.length)
        {
            var txt:FlxText = cast grpSongs.members[i], FlxText;
            txt.color = (i == curSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
        }
    }

    // ========================
    // === SEARCH HANDLING =====
    // ========================
    function handleTyping()
    {
        var before = query;

        if (FlxG.keys.justPressed.ESCAPE && isTyping) isTyping = false;
        if (FlxG.keys.justPressed.BACKSPACE && query.length > 0)
            query = query.substr(0, query.length - 1);
        if (FlxG.keys.justPressed.SPACE) query += " ";

        // letters a-z
        if (FlxG.keys.justPressed.A) query += "a";
        if (FlxG.keys.justPressed.B) query += "b";
        if (FlxG.keys.justPressed.C) query += "c";
        if (FlxG.keys.justPressed.D) query += "d";
        if (FlxG.keys.justPressed.E) query += "e";
        if (FlxG.keys.justPressed.F) query += "f";
        if (FlxG.keys.justPressed.G) query += "g";
        if (FlxG.keys.justPressed.H) query += "h";
        if (FlxG.keys.justPressed.I) query += "i";
        if (FlxG.keys.justPressed.J) query += "j";
        if (FlxG.keys.justPressed.K) query += "k";
        if (FlxG.keys.justPressed.L) query += "l";
        if (FlxG.keys.justPressed.M) query += "m";
        if (FlxG.keys.justPressed.N) query += "n";
        if (FlxG.keys.justPressed.O) query += "o";
        if (FlxG.keys.justPressed.P) query += "p";
        if (FlxG.keys.justPressed.Q) query += "q";
        if (FlxG.keys.justPressed.R) query += "r";
        if (FlxG.keys.justPressed.S) query += "s";
        if (FlxG.keys.justPressed.T) query += "t";
        if (FlxG.keys.justPressed.U) query += "u";
        if (FlxG.keys.justPressed.V) query += "v";
        if (FlxG.keys.justPressed.W) query += "w";
        if (FlxG.keys.justPressed.X) query += "x";
        if (FlxG.keys.justPressed.Y) query += "y";
        if (FlxG.keys.justPressed.Z) query += "z";

        // numbers 0-9
        if (FlxG.keys.justPressed.ZERO) query += "0";
        if (FlxG.keys.justPressed.ONE) query += "1";
        if (FlxG.keys.justPressed.TWO) query += "2";
        if (FlxG.keys.justPressed.THREE) query += "3";
        if (FlxG.keys.justPressed.FOUR) query += "4";
        if (FlxG.keys.justPressed.FIVE) query += "5";
        if (FlxG.keys.justPressed.SIX) query += "6";
        if (FlxG.keys.justPressed.SEVEN) query += "7";
        if (FlxG.keys.justPressed.EIGHT) query += "8";
        if (FlxG.keys.justPressed.NINE) query += "9";

        if (query != before) applyFilter();
    }

    function applyFilter()
    {
        var q = query.toLowerCase().trim();
        songs = (q == "") ? allSongs.copy() : allSongs.filter(function(md) {
            return md.songName.toLowerCase().indexOf(q) != -1;
        });

        rebuildSongItems();
        curSelected = 0;
        changeSelection(0);
    }

    function updateSearchText()
    {
        var caret = (isTyping && caretOn) ? "|" : "";
        searchText.text = "Search: " + query + caret;
    }
}
