function a = est_a( BN_dQdt, Qi, perc )
% given -dQ/dt~Q series and percentage of points fall below the line
% retrun the recession constant a
%
% perc = percentage
%

LEN = size( BN_dQdt, 1 );

NP = ceil( LEN*perc/100.0 );

a = [];

for slope = 0.0001 : 0.0001 : 100
    % Npoints = sum( (Vdata(:,6) < a*Vdata(:,4)) );
    if( sum( (BN_dQdt<slope*Qi),1 ) >= NP )
        a = slope;
        break;        
    end
end

if isempty(a)
    a = 1000;
end
%%