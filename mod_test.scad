function wrap(i,mi,ma)=(i<mi?wrap(i+(ma-mi),mi,ma):i>=ma?wrap(i-(ma-mi),mi,ma):i);
echo("ans:",-1%5);
echo("ans:",wrap(-1,0,5));
echo("ans:",wrap(5,0,5));
