//CHUCK GRANULATOR TUTORIAL -
// GRAIN AS FUNCTION
//See: http://chuck.cs.princeton.edu/doc/language/func.html
//CODE: //https://github.com/elosine/chucK_granulator_tutorial


SndBuf buf1;
"samples/004_glassbreak.wav" => buf1.read;
SndBuf envbuf1;
"grainEnv/gEnv_gauss.aif" => envbuf1.read;

//Declare Function
fun void grain( SndBuf buf, SndBuf envbuf, int pos, float rate, int gdur )
{  
    Gain g;
    1 => g.gain; //add a gain for use later
    g => dac;
    buf => g;
    envbuf => g;
    3 => g.op;
     
    pos => buf.pos;
    rate => buf.rate;
    1 => buf.loop;
    0 => envbuf.pos;
    (envbuf.length() / (ms*gdur)) => envbuf.rate; 
    gdur::ms => now; //will play one grain duration gdur
}


spork ~ grain( buf1, envbuf1, 0, 1.0, 100 ); //run the grain function on its own shred
//See: http://chuck.cs.princeton.edu/doc/language/spork.html

1::day => now;
