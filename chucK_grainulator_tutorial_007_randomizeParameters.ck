//CHUCK GRANULATOR TUTORIAL -
//RANDOMIZE PARAMETERS

100 => int maxGr; 
SndBuf bufs[maxGr]; 
SndBuf envs[maxGr]; 

//Create arrays to hold different samples and envelopes
string samples [4];
"samples/004_glassbreak.wav" => samples[0];
"samples/000_tanpura.wav" => samples[1];
"samples/001_musicbox.aif" => samples[2];
"samples/018_low-glass-bow_stereo.aif" => samples[3];
string envelopes [10];
"grainEnv/gEnv_blackman.aif" => envelopes[0];
"grainEnv/gEnv_expodec.aif" => envelopes[1];
"grainEnv/gEnv_gauss.aif" => envelopes[2];
"grainEnv/gEnv_hamming.aif" => envelopes[3];
"grainEnv/gEnv_hanning.aif" => envelopes[4];
"grainEnv/gEnv_pulse.aif" => envelopes[5];
"grainEnv/gEnv_quasiGauss.aif" => envelopes[6];
"grainEnv/gEnv_rexpodec.aif" => envelopes[7];
"grainEnv/gEnv_threeStageLinear.aif" => envelopes[8];
"grainEnv/gEnv_tri.aif" => envelopes[9];

while (true) 
{      
    for(0 => int i; i < maxGr; i++)
    {  
        
        //Choose sample & envelope
        samples[0] => bufs[i].read;
        envelopes[5] => envs[i].read;
        
        //Choose read position
        // 8000 => int newpos; //use this for reading from the same position each time
        Math.random2( 0, bufs[i].samples() ) => int newpos; 
        //The Math.random2 function will choose a position between the beginning and end of the sample.
        //bufs[i].samples() gives length of the current sample in samples
        //int newpos creates a local variable to pass to the function below
        
        //Choose grain duration
        Math.random2( 50, 150 ) => int grainDur;
        //300 => int grainDur; //use this for fixed grain duration
        
        //Choose gap duration
        Math.random2( 80, 300 ) => int grainGap;
        //300 => int grainGap;
        
        //Choose amplitude
        Math.random2f( 0.01, 1.0 ) => float grainGain;
        //1 => float grainGain; 
        
        //Choose panning
        Math.random2f( -1.0, 1.0 ) => float grainPan;
        //0 => float grainPan; 
        
        //Playback Speed
        Math.random2f( -2.0, 2.0 ) => float gRate;
        //1 => float gRate; 
        
        spork ~ grain( bufs[i], envs[i], newpos, grainDur, grainGain, grainPan, gRate );
        
        grainGap::ms => now; //this is the space between grains
        
    }
    
    15::ms => now;     
}

fun void grain( SndBuf buf, SndBuf envbuf, int pos, int gdur, float grainGain, float grainPan, float grainRate )
{  
    Gain g;
    g => Pan2 p => dac; //added panning ugen
    buf => g;
    envbuf => g;
    3 => g.op;
    
    grainGain => g.gain; //made gain a variable
    grainPan => p.pan; //for panning
    pos => buf.pos;
    grainRate => buf.rate;
    1 => buf.loop;
    0 => envbuf.pos;
    (envbuf.length() / (ms*gdur)) => envbuf.rate; 
    gdur::ms => now; 
}









