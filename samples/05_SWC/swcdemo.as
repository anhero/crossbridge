// Copyright (c) 2013 Adobe Systems Inc

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package
{
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.events.Event;
  import sample.MurmurHash.CModule;
  import sample.MurmurHash.MurmurHash3;

  public class swcdemo extends Sprite
  {
    public function swcdemo()
    {
      addEventListener(Event.ADDED_TO_STAGE, initCode);
    }
 
    public function initCode(e:Event):void
    {
      removeEventListener(Event.ADDED_TO_STAGE, initCode);
      
      CModule.startAsync(this);
      
      var tf:TextField = new TextField();
      tf.multiline = true;
      tf.width = stage.stageWidth;
      tf.height = stage.stageHeight;
      addChild(tf)

      var words:Array = [
        "foo",
        "bar",
        "waz"
      ]

      for each(var word:String in words) {
        var hash:uint = MurmurHash3(word)
        var s:String = "hash of '" + word + "' is: " + hash + "\n"
        tf.appendText( s )
        trace( s )
      }
      
      // test to free memory
      CModule.dispose();
    }
  }
}
