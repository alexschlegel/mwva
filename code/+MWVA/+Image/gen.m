function x = gen(kSuper,kSub,varargin)
% MWVA.Image.gen
% 
% Description:	generate an stimulus image
% 
% Syntax:	x = MWVA.Image.gen(kSuper,kSub,<options>)
% 
% In:
%	kSuper	- the superordinate image category
%	kSub	- the subordinate image category
%	<options>:
%		seed:	(randseed2) the seed to use for randomizing, or false to skip
%				seeding the random number generator
% 
% Out:
% 	x	- the sound signal
% 
% Updated: 2015-09-22
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.

%parse the inputs
	kSuper	= CheckInput(kSuper,'superordinate category',1:2);
	kSub	= CheckInput(kSub,'subordinate category',1:2);

switch kSuper
	case 1	%tonal
		switch kSub
			case 1	%pitch step
				x	= MWVA.Sound.pitch('interp','nearest',varargin{:});
			case 2	%pitch slide
				x	= MWVA.Sound.pitch('interp','bicubic',varargin{:});
		end
	case 2	%atonal
		switch kSub
			case 1	%irregular rhythm
				x	= MWVA.Sound.rhythm('instrument',@sawtooth,varargin{:});
			case 2	%irregular instrument
				x	= MWVA.Sound.rhythm('instrument',{@sin,@sawtooth},'pattern','uniform',varargin{:});
		end
end
