function la_incerto(block)

setup(block);

function setup(block)

block.NumInputPorts  = 2;
block.NumOutputPorts = 1;

% Override input port properties
block.InputPort(1).Dimensions  = 1; %u 
block.InputPort(2).Dimensions  = 1; %V

% Override output port properties
block.OutputPort(1).Dimensions  = 3;

% Register parameters
block.NumDialogPrms = 2;
block.DialogPrmsTunable = {'Tunable','Nontunable'};

% Set up the continuous states.
block.NumContStates = 3;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];

block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs',              @Outputs);     % Required
block.RegBlockMethod('Derivatives',          @Derivatives);
%end setup

function InitializeConditions(block)

block.ContStates.Data = block.DialogPrm(1).Data;
%end InitializeConditions

function Derivatives(block)
  %parametri
  V       =  block.InputPort(2).Data(1);
  L       =  block.DialogPrm(2).Data(2);
  d       =  block.DialogPrm(2).Data(3);
  alpha   =  block.DialogPrm(2).Data(4);
  beta    =  block.DialogPrm(2).Data(5);


   %ingressi
  u = block.InputPort(1).Data(1);
  
    %stati
  x1     = block.ContStates.Data(1);
  x2     = block.ContStates.Data(2);
  x3     = block.ContStates.Data(3);
 
   %equazioni differenziali
   
  dx1 = V*sin(x2)*cos(x3);
  dx2 = sin(x3)*V/L;
  dx3 = u;
  
  block.Derivatives.Data = [dx1,dx2,dx3];

 
%end Derivatives



function Outputs(block)

block.OutputPort(1).Data = block.ContStates.Data ;

