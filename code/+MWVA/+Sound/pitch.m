function x = pitch(varargin)
% MWVA.Sound.pitch
% 
% Description:	parent function of MWVA.Sound.pitch***
% 
% Syntax:	x = MWVA.Sound.pitch(<options>)
% 
% In:
%	strInterp	- the interpolation method
% 	<options>
%		dur:		(1) the total duration of the sound
%		rate:		(44100) the sampling rate
%		seed:		(randseed2) the seed to use for randomizing, or false to skip
%					seeding the random number generator
%		n:			(3) the number of tones in the sequence
%		instrument:	(@sin) the instrument function to use
%		fmin:		(100) the minimum frequency
%		fmax:		(2000) the maximum frequency
%		interp:		('nearest') the pitch interpolation method
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
			'fmin'			, 220		, ...
			'fmax'			, 880		, ...
			'interp'		, 'nearest'	  ...
			);
	
	nSample	= opt.rate*opt.dur;

%choose the tones
	f	= randBetween(opt.fmin,opt.fmax,[opt.n 1],'seed',opt.seed);
	f	= imresize(f,[nSample 1],opt.interp);

%generate the sound
	t	= cumsum(f/opt.rate);
	x	= opt.instrument(2*pi*t);
