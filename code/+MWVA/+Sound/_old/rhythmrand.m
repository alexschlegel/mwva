function x = rhythmrand(varargin)
% MWVA.Sound.rhythmrand
% 
% Description:	generate rhythms using random samples for each beat
% 
% Syntax:	x = MWVA.Sound.rhythmrand(<options>)
% 
% In:
% 	<options>
%		dur:	(1) the total duration of the sound
%		rate:	(44100) the sampling rate
%		seed:	(randseed2) the seed to use for randomizing, or false to skip
%				seeding the random number generator
%		n:		(3) the number of beats in the sequence
% 
% Out:
% 	x	- the sound signal
% 
% Updated: 2015-09-22
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.

%parse some of the options
	opt	= ParseArgs(varargin,...
			'rate'	, 44100	  ...
			);

t		= reshape(0:1/opt.rate:0.05,[],1);
xBeat	=	{
				%square(2*pi*400*t)
				sawtooth(2*pi*400*t)
				sin(2*pi*400*t);
			};

x	= MWVA.Sound.rhythm(xBeat,varargin{:});
