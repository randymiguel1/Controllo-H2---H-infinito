function bicycle(block)

setup(block);

function setup(block)

block.NumInputPorts  = 2;
block.NumOutputPorts = 1;

% Override input port properties
block.InputPort(1).Dimensions  = 1; %u 
block.InputPort(2).Dimensions  = 1; %d 

% Override output port properties
block.OutputPort(1).Dimensions  = 4;

 % Register the parameters.
block.NumDialogPrms     = 2;
block.DialogPrmsTunable = {'Tunable','Nontunable'};

% Set up the continuous states.
block.NumContStates = 4;

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
  m       =  block.DialogPrm(2).Data(1);
  Iz      =  block.DialogPrm(2).Data(2);
  Lf      =  block.DialogPrm(2).Data(3);
  Lr      =  block.DialogPrm(2).Data(4);
  Cf      =  block.DialogPrm(2).Data(5);
  Cr      =  block.DialogPrm(2).Data(6);
  Vx      =  block.DialogPrm(2).Data(7);

  
    %ingressi
  u = block.InputPort(1).Data(1);
  d = block.InputPort(2).Data(1);

  
  
     %stati
  y     = block.ContStates.Data(1);
  dy    = block.ContStates.Data(2);
  w     = block.ContStates.Data(3);
  dw    = block.ContStates.Data(4);
  
     %equazioni differenziali
  dy    = dy;
  ddy   = -2/(m*Vx)*(Cf+Cr)*dy + (2/(m*Vx)*(Cr*Lr-Cf*Lf)-2*Vx)*dw + 2*Cf/m*(d+u);
  dw    = dw;
  ddw   = -2/(Iz*Vx)*(Lr*Cr-Lf*Cf)*dy - 2/(Iz*Vx)*(Lr^2*Cr+Lf^2*Cf)*dw + 2*Lf*Cf/Iz*(d+u);
  
  block.Derivatives.Data = [dy; ddy; dw; ddw];
  
  %end Derivatives
  
function Outputs(block)

block.OutputPort(1).Data = block.ContStates.Data ;

 
