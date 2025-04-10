[\<\<IDMish\>\> by xffff](https://sccode.org/1-4QE)

This is a random noise IDM (Intelligent Dance Music) music generator. 

(  
fork{  
	loop{ | i |   
[fork](https://doc.sccode.org/Classes/Function.html#-fork): It starts a [Routine](https://doc.sccode.org/Classes/Routine.html), and plays it in a TempoClock. So it is good for time-based actions.  
[loop](https://doc.sccode.org/Classes/Function.html#-loop): Repeat this function indefinitely.

		var time, trigtime;  
		time \= \[1/8,1/4,1\].wchoose(\[2,1,0.2\].normalizeSum);  
		trigtime \= \[1,2,4,8,16\].choose;  
2 variables are defined here.  
[wchoose](https://doc.sccode.org/Classes/SequenceableCollection.html#-wchoose): Choose an element from the collection at random using a list of probabilities or weights. The weights must sum to 1.0.  
[normalizeSum](https://doc.sccode.org/Classes/Array.html#-normalizeSum): Returns the Array to sum to 1.0  
[choose](https://doc.sccode.org/Classes/SequenceableCollection.html#-choose): Choose an element from the collection at random.

		play{		  
			var sound, freq, ampenv, filterenv, mod, snare, snaretrig, kick, kickenv, lin;  
10 more variables are defined here.  
						  
			mod \= LFNoise2.kr({0.01.rand}.dup(2), \[0.01.rand,0.001.rand,0.5.rand\].choose, 1.0);  
[LFNoise2](https://doc.sccode.org/Classes/LFNoise2.html): a low-frequency noise generator.  
**LFNoise2.kr(freq: 500.0, mul: 1.0, add: 0.0)**  
[{0.01.rand}.dup(2)](https://doc.sccode.org/Classes/Float.html):Generate 2 random floats between 0 and 0.01.  
[\[0.01.rand,0.001.rand,0.5.rand\].choose](https://doc.sccode.org/Classes/SequenceableCollection.html#-choose): Choose a number from the collection at random. The three numbers in the collection are also randomized.   
			  
			freq \= \[  
					Scale.minorPentatonic.degrees,  
					Scale.minorPentatonic.degrees.choose  
				\].choose \+ (12 \* (2..6).choose);  
			freq \= freq.midicps;  
[Frequencies](https://doc.sccode.org/Classes/Scale.html#*choose) are chosen from minor pentatonic scales at random. And it is summed with the result from generating [a random integer between 2 and 6 (inclusive)](https://doc.sccode.org/Classes/ArrayedCollection.html#-copySeries) and multiplying it by 12\. So it generates random frequencies from minor pentatonic scales at random octaves.   
[midicps](https://doc.sccode.org/Classes/AbstractFunction.html#-midicps): Converts midinote into cycles per seconds (Hz).  
			  
			filterenv \= EnvGen.kr(Env.linen(time/3.0.rand.max(0.01),time/3.0.rand.max(0.01),time/3.0.rand.max(0.01)).range(freq\*1.5,freq\*10.0.rand.max(1.5))  
			);  
[**Env.linen(attackTime: 0.01, sustainTime: 1.0, releaseTime: 1.0, level: 1.0, curve: 'lin').range(lo: 0.0, hi: 1.0)**](https://doc.sccode.org/Classes/Env.html#*linen)**:**  
Attack, sustain, and release durations are defined by time/3.0.rand.max(0.01).  
It divides time, which is defined above, into thirds, and then picks a random value up to that third, ensuring it is at least 0.01 seconds to avoid zero-duration.   
.range maps the envelope output into a new range. It defines min \= freq\*1.5 and max \= somewhere between 1.5\*freq and 10\*freq, depending on the random value.  
			  
			ampenv \= EnvGen.kr(Env.perc(0.01,time/2.0.rand.max(1/8),1.0.rand),doneAction:2);  
[**EnvGen.kr(envelope, gate: 1.0, levelScale: 1.0, levelBias: 0.0, timeScale: 1.0, doneAction: 0\)**](https://doc.sccode.org/Classes/EnvGen.html)**:**  
doneAction: Once the envelope finishes, this tells the synth to free itself.  
[**Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 1.0, curve: \-4.0)**](https://doc.sccode.org/Classes/Env.html#*perc)**:** It creates a percussive envelope.  
Attack time: 0.01 seconds  
Release time: .rand gives a random float between 0 and half of time and .max(1/8) ensures it’s at least 0.125 seconds. So it is defined somewhere between 0.125 and half of the time, depending on the random value.  
Level: random amplitude between 0.0 and 1.0  
			  
			sound \= Select.ar(5.rand, \[  
				Pulse.ar(freq\*mod,0.5).tanh,  
				LFTri.ar(freq\*mod,0).tanh,  
				Pulse.ar(freq\*mod,0.5).tanh,  
				LFSaw.ar(freq\*mod,0.5).tanh,		  
				SinOscFB.ar(freq\*mod,100.0.rand).tanh  
			\]);   
[**Select.ar(which, array)**](https://doc.sccode.org/Classes/Select.html)**:**  
**5.rand** : it picks a random integer from 0 to 4, so it gets one of the five oscillator options in the array.  
[**Pulse.ar(freq\*mod,0.5)**](https://doc.sccode.org/Classes/Pulse.html)**:** band limited pulse wave. Frequency is modulated by variables mod. Width is 0.5.  
[**LFTri.ar(freq\*mod,0)**](https://doc.sccode.org/Classes/LFTri.html)**:** a non-band-limited triangle oscillator. Frequency is modulated. 0 phase offset.  
[**LFSaw.ar(freq\*mod,0.5)**](https://doc.sccode.org/Classes/LFSaw.html): a non-band-limited sawtooth oscillator. Frequency is modulated. 0 initial phase offset.  
[**SinOscFB.ar(freq\*mod,100.0.rand)**](https://doc.sccode.org/Classes/SinOscFB.html): a sine oscillator with phase modulation feedback. Frequency is modulated. Frequency amount is randomized from 0 to 100\.  
**.than**: it applies non-linear distortion.  
			  
			sound \= RLPF.ar(sound, filterenv, LFNoise2.kr(0.01.rand, 0.3, 0.5) );  
			sound \= sound \* ampenv;  
[**RLPF.ar(in: 0.0, freq: 440.0, rq: 1.0, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/RLPF.html): a resonant low pass filter.  
Q is modulated by LFNoise2.  
			  
			sound \= sound \+ (DelayC.ar(sound, 1/4, {\[1/4,1/8\].choose}.dup(2)) \* \[1.0.rand,0\]);  
[**DelayC.ar(in: 0.0, maxdelaytime: 0.2, delaytime: 0.2, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/DelayC.html): a simple delay.  
Delay time is randomly picked either 0.25 or 0.125 seconds, twice to make a stereo array.  
			  
			5.do{sound \= (sound.clip \+ sound)\*0.75};  
**sound.clip**: applies hard clipping to keep everything in range \[-1, 1\].  
Then, the code combines the original and the clipped version of the signal, and reduces gain by multiplying 0.75.  
This is repeated five times.

			sound \= LPF.ar(sound, LFNoise2.kr(trigtime, 250, 500) );  
[**LPF.ar(in: 0.0, freq: 440.0, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/LPF.html): a second order low pass filter.  
Frequency is modulated by LFNoise2.  
	  
			snaretrig \= Impulse.kr(trigtime);  
			snare \= 3\*PinkNoise.ar(1\!2) \*   
				EnvGen.kr(Env.perc(0.01,0.01,\[0,0.3.rand\].choose),snaretrig);  
			5.do{snare \= AllpassC.ar(snare, 0.5, {0.05.rand}.dup(2), 1.0.rand)+snare};  
			5.do{snare \= (snare.distort \+ snare)\*0.85};  
[**Impulse.kr(freq: 440.0, phase: 0.0, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/Impulse.html): generates a series of trigger pulses at a given frequency.  
[**PinkNoise.ar(mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/PinkNoise.html)**:** Pink Noise. 1\!2 creates a stereo array of identical values: \[1,1\].  
Level is modulated by snaretrig variables.  
[**AllpassC.kr(in: 0.0, maxdelaytime: 0.2, delaytime: 0.2, decaytime: 1.0, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/AllpassC.html): it delays the signal a little bit, creating a blurry attack.   
	  
			kickenv \= EnvGen.kr(Env.perc(0.01,time,\[0,1.0.rand\].choose));  
			kick \= SinOsc.ar(40\!2\+(kickenv\*\*3\*200),0,7\*kickenv) \* kickenv;   
			5.do{kick \= (kick.distort \+ kick)\*0.75};  
[**SinOsc.ar(freq: 440.0, phase: 0.0, mul: 1.0, add: 0.0)**](https://doc.sccode.org/Classes/SinOsc.html): a sine wave.  
40\!2 creates a stereo 40 Hz tone, and \+(kickenv\*\*3\*200) adds a really quick pitch sweep to generate attack on the sound.    
			  
			sound \= Limiter.ar(sound \+ snare \+ kick, 1.0, 0.00001);  
[**Limiter.ar(in: 0.0, level: 1.0, dur: 0.01)**](https://doc.sccode.org/Classes/Limiter.html): a peak limiter.  
						  
			Out.ar(0,sound.tanh);  
[**Out.ar(bus, channelsArray)**](https://doc.sccode.org/Classes/Out.html)  
		};  
		  
		time.wait;  
	};  
}  
)  
