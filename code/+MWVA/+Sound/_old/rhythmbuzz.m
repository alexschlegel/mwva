function x = rhythmbuzz(varargin)
% MWVA.Sound.rhythmbuzz
% 
% Description:	generate buzz rhythms
% 
% Syntax:	x = MWVA.Sound.rhythmbuzz(<options>)
% 
% In:
% 	<options> (see MWVA.Sound.rhythm)
% 
% Out:
% 	x	- the sound signal
% 
% Updated: 2015-09-22
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.
x	= MWVA.Sound.rhythm('instrument',@sawtooth,varargin{:});
