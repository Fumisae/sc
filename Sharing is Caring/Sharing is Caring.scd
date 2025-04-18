// Start server and MIDI
s.boot;
MIDIClient.init;
MIDIIn.connectAll;

// Create a MIDI control bus
~midiVolumeBus = Bus.control(s, 1).set(0.5); // Default volume 0.5

// Listen to MIDI CC (change 1 to your slider's CC number)
MIDIdef.cc(\volumeControl, { |val|
    ~midiVolumeBus.set(val/127); // Convert 0-127 to 0.0-1.0
}, ccNum: 1); // Replace 1 with your MIDI slider's CC number

// Stereo bass riff with enhanced spatial movement
(
Ndef(\bass_riff_to_noise, {
    var fibSeq = fib(12).wrap(40, 72).midicps;
    var a = Demand.ar(Impulse.ar(10), 0, Dseq(fibSeq, inf));

    // Create two slightly detuned oscillators for stereo width
    var oscL = LFCub.ar(a * 1.005); // Slightly higher freq
    var oscR = LFCub.ar(a * 0.995); // Slightly lower freq

    // Apply effects to each channel separately
    var procL = HPF.ar(LeakDC.ar(oscL * 3).distort, 80) * 0.3;
    var procR = HPF.ar(LeakDC.ar(oscR * 3).distort, 80) * 0.3;

    // Add stereo movement with slow panning
    var panned = Balance2.ar(procL, procR);

    // Apply MIDI volume and ensure stereo output
    panned * In.kr(~midiVolumeBus.index);
}).play;
)