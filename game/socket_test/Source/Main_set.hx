import flash.display.Sprite;
import flash.net.Socket;
import flash.events.*;
import flash.events.DataEvent;
import flash.text.*;
import flash.events.KeyboardEvent;
import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.ICadeKeyCode;

class Main extends Sprite
{
    private var debugText:TextField;
    private var _keyListener:ICadeKeyboard;
    private var controllers : Map<String,Main.PlayerController>;
    private var players:Array<Player>;
    private var socket:flash.net.Socket;
    private var playerID:String;
    private var colors:Array<Int>;
    public function new ()
	{
		super();
        
        // setup colors
        colors = new Array<Int>();
        colors.push(0x00ff00);
        colors.push(0xff0000);
        colors.push(0xcc2200);
        colors.push(0x2200cc);


        // debug
        debugText = new TextField();
		debugText.autoSize = TextFieldAutoSize.LEFT;
        this.addChild(debugText);

        // init
        players = new Array<Player>();
        controllers = new Map<String,PlayerController>();

        // socket
        socket = new flash.net.Socket();
        socket.timeout = 1000;
        AppendText("socket created");
        socket.addEventListener(Event.CONNECT,OnSocketConnect);
        socket.addEventListener(Event.CLOSE,OnSocketClosed);
        socket.addEventListener(ProgressEvent.SOCKET_DATA,OnSocketData);
        socket.connect("127.0.0.1",8888);
        AppendText("socket connected");
        //socket.writeUTF("Hello");

        // keyboard
        _keyListener = new ICadeKeyboard();
        _keyListener.setKeyboardMode(true); // viktigt för att man inte skall bli galen =)
        _keyListener.addEventListener(KeyboardEvent.KEY_DOWN,OnKeyDown);
        _keyListener.addEventListener(KeyboardEvent.KEY_UP,OnKeyUp);

        // main loop
        this.addEventListener(Event.ENTER_FRAME,OnEnterFrame);
	}

    public function AddPlayer(id:String,x:Float,y:Float)
    {
        var controller = new PlayerController(x,y);
        controller.id = id;
        controllers.set(id,controller);
        var player = new Player(controllers[id],colors[Std.parseInt(id)]);
        players.push(player);
        this.addChild(player);
        AppendText("player"+" : " + id + " - length: " + players.length);
        socket.writeUTFBytes(controller.id+":"+controller.x+":"+controller.y+":");
    }

    public function OnEnterFrame(e:Event)
    {
        if(socket.connected && playerID!=null && keyDown)
        {
            var pc = controllers[playerID];
            pc.update();
            socket.writeUTFBytes(pc.id+":"+pc.x+":"+pc.y+"|");
        }
        
        for(i in 0...players.length)
            players[i].update();
    }

    public function OnSocketData(e:ProgressEvent)
    {
        if(socket.bytesAvailable!=0)
        {   
            var data = socket.readUTFBytes(socket.bytesAvailable);
            var packetSegments = data.split('|');
            var dataSegments = packetSegments[0].split(':');
            AppendText("ja->" + data);
            var id = dataSegments[0];
            var x:Int = Std.parseInt(dataSegments[1]);
            var y:Int = Std.parseInt(dataSegments[2]);

            // adding ME
            if(id.charAt(0)=='+')
            {
                id = id.substring(1);
                playerID = id;
            }

            // adding ME/PLAYERS
            if(!controllers.exists(id))
                AddPlayer(id,x,y);

            AppendText(data);

            controllers[id].x = x;
            controllers[id].y = y;
        }
    }

    public function OnSocketClosed(e:ProgressEvent)
    {
        AppendText("socket closed");
    }

    public function OnSocketConnect(e:Event)
    {
        AppendText("connected");
    }

    public function AppendText(text:String)
    {
        Sys.println(text);
    }

    private var keyDown:Bool;
    public function OnKeyDown(e:KeyboardEvent)
    {
        switch(e.keyCode)
        {
            case 68: controllers[playerID].dx=1;
            case 65: controllers[playerID].dx=-1;
            case 87: controllers[playerID].dy=-1;
            case 83: controllers[playerID].dy=1;
        }
        keyDown = true;
        //AppendText(Std.string(e.keyCode));
    }

    public function OnKeyUp(e:KeyboardEvent)
    {
        switch(e.keyCode)
        {
            case 68: controllers[playerID].dx=0;
            case 65: controllers[playerID].dx=0;
            case 87: controllers[playerID].dy=0;
            case 83: controllers[playerID].dy=0;
        }
        keyDown = false;
    }
}



class PlayerController
{
    public var id:String; // tilldelat av server
    public var dx:Float;
    public var dy:Float;
    public var x:Float;
    public var y:Float;
    public function new(x:Float,y:Float)
    {
        this.x = x;
        this.y = y;
    }

    public function update()
    {
        this.x+=dx;
        this.y+=dy;
    }
}

class Player extends Sprite
{
    private var _controller:PlayerController;
    public function new(controller:PlayerController,color:Int)
    {
        super();
        _controller = controller;
        this.graphics.beginFill(color);
        this.graphics.drawRect(100,100,100,100);
        this.graphics.endFill();
    }

    public function update()
    {
        this.x=_controller.x;
        this.y=_controller.y;
    }
}