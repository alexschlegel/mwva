function x = rhythm(varargin)
% MWVA.Sound.rhythm
% 
% Description:	parent function of MWVA.Sound.rhythm***
% 
% Syntax:	x = MWVA.Sound.rhythm(<options>)
% 
% In:
% 	<options>
%		dur:		(1) the total duration of the sound
%		rate:		(44100) the sampling rate
%		seed:		(randseed2) the seed to use for randomizing, or false to
%					skip seeding the random number generator
%		n:			(3) the number of beats in the sequence
%		instrument:	(@sin) the instrument function to use, or a cell array of
%					instrument functions to choose a random instrument for each
%					beat
%		f:			(400) the frequency of the beat, in Hz
%		pattern:	('random') the type of rhythm pattern:
%						'random':	a random rhythm
%						'uniform':	a uniformly spaced sequence
% 
% Out:
% 	x	- the sound signal
% 
% Updated: 2015-09-22
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.

%parse the inputs
	opt	= ParseArgs(varargin,...
			'dur'			, 1			, ...
			'rate'			, 44100		, ...
			'seed'			, []		, ...
			'n'				, 3			, ...
			'instrument'	, @sin		, ...
			'f'				, 400		, ...
			'pattern'		, 'random'	  ...
			);
	
	opt.instrument	= ForceCell(opt.instrument);
	
	opt.pattern	= CheckInput(opt.pattern,'pattern',{'random','uniform'});
	
	nSample	= opt.rate*opt.dur;

%seed the random number generator
	rng2(opt.seed);

%choose the beat times
	nSampleBeat	= floor(nSample/(4*opt.n));
	
	switch opt.pattern
		case 'random'
			nBeatStep	= 2*nSampleBeat;
			kBeatMax	= nSample - nSampleBeat + 1;
			kBeatAll	= 1+nBeatStep:nBeatStep:kBeatMax;
			kBeat		= [1; randFrom(kBeatAll,[opt.n-1 1],'seed',false)];
		case 'uniform'
			nBeatStep	= 4*nSampleBeat;
			kBeatMax	= nSample - nBeatStep + 1;
			kBeat		= 1:nBeatStep:kBeatMax;
	end

%generate the sound
	x	= zeros(nSample,1);
	
	for k=1:opt.n
		kStart	= kBeat(k);
		kEnd	= kBeat(k) + nSampleBeat - 1;
		
		fBeat	= cell2mat(randFrom(opt.instrument,'seed',false));
		tBeat	= (1:nSampleBeat)/opt.rate;
		xBeat	= reshape(fBeat(2*pi*opt.f*tBeat),[],1);
		
		x(kStart:kEnd)	= x(kStart:kEnd) + xBeat;
	end
	
	x	= min(1,max(-1,x));
