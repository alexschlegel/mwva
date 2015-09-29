classdef MWVA < PTB.Object
% MWVA
%
% Description:	the mwva experiment object
%
% Syntax: mwva = MWVA(strSession,<options>)
%
% In:
%	strSession	- the session type:
%					'train':	a training session
%					'fmri':		an fMRI session
%	<options>
%
%			subfunctions:
%				Start(<options>):	start the object
%				End:				end the object
%				Prepare:			prepare necessary info
%				Train:				run a training session
%				Practice:			run a practice sequence
%				Run:				execute an mwva run
%
% Updated: 2015-09-22
% Copyright 2015 Alex Schlegel (schlegel@gmail.com).  This work is licensed
% under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
% License.

	%PUBLIC PROPERTIES---------------------------------------------------------%
	properties
		Experiment;
		Key;
	end
	%PUBLIC PROPERTIES---------------------------------------------------------%
	
	
	%PRIVATE PROPERTIES--------------------------------------------------------%
	properties (SetAccess=private, GetAccess=private)
		session;
		argin;
	end
	%PRIVATE PROPERTIES--------------------------------------------------------%
	
	
	%PROPERTY GET/SET----------------------------------------------------------%
	methods
		
	end
	%PROPERTY GET/SET----------------------------------------------------------%
	
	
	%PUBLIC METHODS------------------------------------------------------------%
	methods
		function mwva = MWVA(strSession,varargin)
			mwva	= mwva@PTB.Object([],'mwva');
			
			mwva.session	= CheckInput(strSession,'session type',{'train','fmri'});
			mwva.argin		= varargin;
			
			%parse the inputs
				strContextDefault	= switch2(mwva.session,'train','psychophysics','fmri','fmri');
				
				opt = ParseArgs(varargin,...
					'name'			, 'mwva'			, ...
					'context'		, strContextDefault	, ...
					'tr'			, MWVA.Param('tr')	, ...
					'background'	, 
					'text_color'	, 
					'text_size'		, 
					'text_family'	, 
					'skypsynctests'	, 
					'input_scheme'	, 
					'debug'			, 0 	  ...
					);
				
				opt.name	= 'gridop';
				opt.context	= 'fmri';
				opt.tr		= GO.Param('time','tr');
			
			%window
				opt.background	= GO.Param('color','back');
				opt.text_color	= GO.Param('color','text');
				opt.text_size	= GO.Param('text','size');
				opt.text_family	= GO.Param('text','font');
                opt.skipsynctests = true;
			
			opt.input_scheme	= 'lr';
			
			% get existing subjects
			global strDirData
			cSubjectFiles	= FindFiles(strDirData, '^\w\w\w?\w?\.mat$');
			
			%options for PTB.Experiment object
			cOpt = opt2cell(opt);
			
			%initialize the experiment
			go.Experiment	= PTB.Experiment(cOpt{:});
			
			%add a keyboard object
			go.Key	= PTB.Device.Input.Keyboard(go.Experiment);
			
			%set the session
				subInit	= go.Experiment.Info.Get('subject','init');
				% check whether a subject file exists for this experiment
				bPreDefault	= ~any(strcmp(cSubjectFiles,PathUnsplit(strDirData, subInit, 'mat')));
				kSession	= NaN;
				go.Experiment.Scheduler.Pause;  % so the prompt doesn't get covered by log entries
				while isnan(kSession)
					strSession = go.Experiment.Prompt.Ask('Select session:',...
						'choice',{'pre','post'},'default', ...
						conditional(bPreDefault,'pre','post'));
					switch strSession
						case 'pre'
							kSession	= 1;
						case 'post'
							kSession	= 2;
						otherwise
							continue
					end
				end
				go.Experiment.Scheduler.Resume;
				go.Experiment.Info.Set('go','session',kSession);
			
			%start
			go.Start;
		end
		%----------------------------------------------------------------------%
		function Start(go,varargin)
		%start the gridop object
			go.argin	= append(go.argin,varargin);
			
			if ~notfalse(go.Experiment.Info.Get('go','prepared'))
				%prepare info
				go.Prepare(varargin{:});
			end
		end
		%----------------------------------------------------------------------%
		function End(go,varargin)
		%end the gridop object
			v	= varargin;
            
			go.Experiment.End(v{:});
			
			disp(sprintf('Final reward: $%.2f',go.reward));
		end
		%----------------------------------------------------------------------%
	end
	%PUBLIC METHODS------------------------------------------------------------%
end
