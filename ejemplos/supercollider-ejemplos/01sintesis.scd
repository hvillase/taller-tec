// Sintesis

s.boot; // prender supercollider
s.quit; // apagar supercollider

// 1 aditiva
(
SynthDef(\aditiva, {|f1=200, f2=300, f3=400, f4=500, a1=0.1, a2=0.1, a3=0.1, a4=0.1, amp=1, gate=1, out=0|
	var sin1, sin2, sin3, sin4, pan, env;
	sin1=SinOsc.ar(f1, 0, a1);
	sin2=SinOsc.ar(f2, 0, a2);
	sin3=SinOsc.ar(f3, 0, a3);
	sin4=SinOsc.ar(f4, 0, a4);
	pan=Pan2.ar(sin1 + sin2 + sin3 + sin4, 0, amp);
	env= EnvGen.ar(Env([0,1,0], [0.01, 0.75]), gate, doneAction:2);
	Out.ar(out, pan * env)
}).add
)

a=Synth(\aditiva);

// 2 sustractiva
(
SynthDef(\sustractiva, {|amp=0.1, fc=500, rq=1, gate=1, at=0.1, rel=0.1, out=0|
	var noise, pan, filtro, env;
	noise = WhiteNoise.ar(amp);
	pan = Pan2.ar(noise, 0);
	filtro = BPF.ar(pan, fc, rq);
	env=EnvGen.ar(Env([0, 1, 0],[at, rel]), gate, doneAction:2);
	Out.ar(out, filtro * env)
}).add
)

Synth(\sustractiva, [\rel, 1, \fc, 1000, \rq, 0.1, \amp, 0.5])

// 3 síntesis por modulación am y fm
(
SynthDef(\am, {|freq=400, modulador = 10, amp=0.5, gate=1, out=0|
	var sen, pan, env;
	sen=SinOsc.ar(freq, 0, SinOsc.ar(modulador, 0, 0.2, 0.2));
	pan=Pan2.ar(sen, 0, amp);
	env=EnvGen.kr(Env([0,1,0],[0.1, 1]), gate, doneAction:2);
	Out.ar(out, pan * env)
}).add
)

Synth(\am);

(
SynthDef(\fm, {|carrier = 250, modulador=2, index=10, amp=0.5, gate=1, out = 0|
	var sen, pan, env;
	sen=SinOsc.ar(carrier + SinOsc.ar(modulador, 0, index), 0, amp);
	pan=Pan2.ar(sen, 0);
	env=EnvGen.kr(Env([0, 1, 0],[0.1, 1]), gate, doneAction:2);
	Out.ar(out, pan * env)
}).add
)

Synth(\fm, [\carrier, 530, \modulador, 10, \index, 10, \amp, 0.2]);

// 4 secuencia

(
Pdef(\sintesis, Pbind(\instrument, \aditiva,
	\dur, Pseq([0.5, 1, 0.25], inf),
	\f1, Pseq([300, 400, 500], inf),
	\f2, Pseq([550, 600, 670], inf),
	\amp, 0.9
)).stop
)

(
Pdef(\sintesis, Pbind(\instrument, \sustractiva,
	\dur, Pseq([0.5, 1, 0.25], inf),
	\fc, Pseq([500, 200, 1000], inf),
	\amp, 0.4
)).play
)

(
Pdef(\sintesis, Pbind(\instrument, \am,
	\dur, Pseq([0.5, 1, 0.25], inf),
	\freq, Pseq([500, 200, 800], inf),
	\modulador, Pseq([20, 40, 8, 10, 5], inf),
	\amp, 0.4
)).stop
)

(
Pdef(\sintesis, Pbind(\instrument, \fm,
	\dur, Pseq([0.5, 1, 0.25, 0.5, 1], inf),
	\carrier, Pseq([500, 200, 1000, 300, 200], inf),
	\modulador, Pseq([20, 9, 50],inf),
	\amp, 0.1
)).stop
)

// grabación
// Presionar Start Recording en el cuadro de la esquina inferior derecha
// Buscar la ruta de los sonidos
Platform.recordingsDir;
