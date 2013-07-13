(
var width= 1600, height= 900;
var win= Window("text", Rect(1, 1, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));
var str;
var fnt= Font("", 9);
usr.background= Color.white;
CmdPeriod.doOnce({win.close});
win.front;
usr.drawFunc= {
	1000.do { |i|
var text = ["Hier und jetzt. To intersperse. Now and then. Nun also. Mainteant. Ab jetzt. Ce soir. Nämlich. So what. Tomorrow. Übermorgen. The day after. Da und dort. Das Da! Here and overthere. Diesseits. Noch weiter. Yet another. Always further. Weiter unten."];
var snake = ContextSnake(text, "Hier", 2);
var strm = snake.asStream.all.join;
var prob = strm.size;
	Pen.push;
	str= strm;
	Pen.translate(0, 0);
	Pen.scale(1.0, 1.0);
	//Pen.skew(rrand(0.0, 1.0), 0);
		Pen.stringAtPoint(str, Point(0, rrand(0.1, prob)), fnt, Color.new(0, 0, 0, rrand(0.0, prob/1000)));
	Pen.pop;
}};
)



