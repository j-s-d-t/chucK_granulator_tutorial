//CHUCK GRANULATOR TUTORIAL -
//MULTIPLE GRAINS
//CODE: //https://github.com/elosine/chucK_granulator_tutorial

100 => int grainDur;
20 => int grainGap;
SndBuf buf, envbuf;

300 => int repeats;

(repeats * grainGap) => int playdur;

repeat (repeats)
{        
    //We fill the buffers, within the repeat loop, 
    //just before creating the grain.
    "samples/001_musicbox.aif" => buf.read;
    "grainEnv/gEnv_gauss.aif" => envbuf.read;
    
    spork ~ grain( buf, envbuf, 0, grainDur );
    
    grainGap::ms => now; //this is the space between grains
    
}

playdur::ms => now;


fun void grain( SndBuf buf, SndBuf envbuf, int pos, int gdur )
{  
    Gain g;
    1 => g.gain;
    g => dac;
    buf => g;
    envbuf => g;
    3 => g.op;
    
    pos => buf.pos;
    1 => buf.rate;
    1 => buf.loop;
    0 => envbuf.pos;
    (envbuf.length() / (ms*gdur)) => envbuf.rate; 
    gdur::ms => now; 
}









