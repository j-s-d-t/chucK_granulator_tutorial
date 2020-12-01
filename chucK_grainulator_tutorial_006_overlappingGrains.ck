//CHUCK GRANULATOR TUTORIAL -
//OVERLAPPING GRAINS
//CODE: //https://github.com/elosine/chucK_granulator_tutorial

//See: http://chuck.cs.princeton.edu/doc/language/spork.html100 => int maxGr;

//To have overlapping grains,
//we will need multiple sample and envelope buffers.
100 => int maxGr; //maximum concurrent grains
SndBuf bufs[maxGr]; //array to store all of the sample buffers
SndBuf envs[maxGr]; //array to store all of the envelope buffers
0 => int ix; //an indexer to count through the buffers

20 => int grainDur;
110 => int grainGap;

24500 => int positon;

while (true) //infinite loop
{      
    for(0 => int i; i < maxGr; i++)
    {  
        
        //read to unique buffer for each grain up to maxGr
        "samples/000_tanpura.wav" => bufs[i].read;
        "grainEnv/gEnv_gauss.aif" => envs[i].read;

        (Math.random2( 0, 200 ) + positon) => int newpos;
        
        spork ~ grain( bufs[i], envs[i], newpos, grainDur );
        
        grainGap::ms => now; //this is the space between grains
        
    }
    
    1::samp => now; //frame rate
}



fun void grain( SndBuf buf, SndBuf envbuf, int pos, int gdur )
{  
    Gain g;
    0.5 => g.gain;
    g => dac;
    buf => g;
    envbuf => g;
    3 => g.op;
    
    pos => buf.pos;
    0.4 => buf.rate;
    1 => buf.loop;
    0 => envbuf.pos;
    (envbuf.length() / (ms*gdur)) => envbuf.rate; 
    gdur::ms => now; 
}









