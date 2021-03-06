function x = pitchstep(varargin)
% MWVA.Sound.pitchstep
% 
% Description:	step between pitches
% 
% Syntax:	x = MWVA.Sound.pitchstep(<options>)
% 
% In:
% 	<options> (see MWVA.Sound.pitch)
% 
% Out:
% 	x	- the sound signal
% 
% Updated: 2015-09-21
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.
x	= MWVA.Sound.pitch('nearest',varargin{:});
