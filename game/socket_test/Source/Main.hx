import flash.display.Sprite;
import flash.net.Socket;
import flash.events.*;
import flash.events.DataEvent;
import flash.text.TextField;

class Main extends Sprite
{
	private var debugText:TextField;
    public function new ()
	{
		super ();
        debugText = new TextField();
        this.addChild(debugText);

        var socket = new flash.net.Socket();
        AppendText("socket created");

        // adding eventlisteners
        socket.addEventListener(Event.CONNECT,function(e:Event){AppendText("connected");});
        socket.addEventListener(Event.CLOSE,function(e:Event){AppendText("closed");});
        socket.addEventListener(ProgressEvent.SOCKET_DATA,function(e:ProgressEvent)
            {
                AppendText("incoming data");
                if(socket.bytesAvailable!=0)
                {
                    var s:String = socket.readUTFBytes(socket.bytesAvailable);
                    AppendText(s);
                }
                
            });
        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(e:SecurityErrorEvent){AppendText("error" + e.text);});

        socket.connect("127.0.0.1",8889);
        AppendText("socket connected");

        socket.writeUTF("hello from flash");
	}

    public function AppendText(text:String)
    {
        debugText.text = text + '\n' + debugText.text;

    }
}