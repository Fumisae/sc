(
{
	var in, chain;
	in = PSinGrain.ar(220, 10);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_Diffuser(chain, PinkNoise.kr(1, 0));
	2 * IFFT(chain).dup;
}.play
);
