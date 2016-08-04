function xy = PolyDraw(varargin)
%% PolyDraw.m USAGE NOTES AND CREDITS
% 
% Syntax
% -----------------------------------------------------
%     PolyDraw()
%     PolyDraw(ax)
%     PolyDraw(...,2)
%     PolyDraw(...,...,sec)
%     xy = PolyDraw(__)
%
% 
% Description
% -----------------------------------------------------
%     PolyDraw() This is a minimal function for drawing polygon shapes on an 
%     existing figure axis. The DrawPoly function will then return the 
%     x,y coordinates of those points. 
%
%
% Useage Definitions
% -----------------------------------------------------
% 
% 
%   xy = PolyDraw
% 
%     PolyDraw EVOKED WITH 0 INPUTS DEFAULTS TO CURRENT AXIS
%     AND SPECIFIES LINE DRAWING THAT WILL REMAIN ON THE FIGURE
%     AFTER DRAWING IS COMPLETE. EasyDraw RETURNS THE XY
%     COORDINATES FOR THE (CLOSED) POLYGON DRAWN ON THE FIGURE
% 
% 
% xy = PolyDraw(axis_handle);
% 
%     1st INPUT SPECIFIES AN AXIS HANDLE (1 == USE CURRENT AXIS);
% 
% 
% xy = PolyDraw(1,2);
% 
%     2nd INPUT SPECIFIES LINE (1 |DEFAULT) OR SPLINE (2) DRAWING
% 
% 
% xy = PolyDraw(1,2,.5);
% 
%     3rd INPUT SPECIFIES WHETHER TO KEEP (-1 |DEFAULT) OR DELETE (0)
%     THE LINE POLYGON; ANY OTHER POSITIVE NUMBER INPUT (e.g. 1.5)
%     IN THIS ARG POSITION WILL DELETE THE POLYGON AFTER A PAUSE 
%     OF THAT LENGTH (e.g. pause(1.5) )
% 
% 
% 
% 
% Examples
% -----------------------------------------------------
% 
% First create a figure, axis, and (optionally) a plot
% 
%     fh1 = figure(1);
%     ax1 = axes('Position',[.1 .1 .8 .8]);
% 
%     x = 0:pi/100:2*pi;
%     y = sin(x);
%     ph1 = plot(x,y);
%           ylim([-1.2 1.2])
% 
% 
% Then evoke PolyDraw with zero or more args
% 
%     PolyDraw();
% 
% 
% Evoke PolyDraw with an axis handle arg and return the x,y coordinates
% 
%     xy = PolyDraw(ax1);
% 
% 
% Evoke PolyDraw and create a spline over the polygon points
% 
%     xy = PolyDraw(1,2);         % SPLINE W/ DEFAULT AXIS
%     xy = PolyDraw(ax1,2);       % SPLINE W/ SPECIFIED AXIS
% 
% 
% Evoke PolyDraw and delete (or keep) the polygon on the figure
% 
%     xy = PolyDraw(1,2,-1);      % KEEP IT (THE LINE POLYGON)
%     xy = PolyDraw(1,2,-1);      % KEEP IT (THE SPLINE CURVE)
%     xy = PolyDraw(1,2,0);       % DELETE IT (THE SPLINE CURVE) ASAP
%     xy = PolyDraw(1,1,0);       % DELETE IT (THE LINE POLYGON) ASAP
%     xy = PolyDraw(1,1,.5);      % DELETE IT (THE LINE POLYGON) AFTER .5 SECONDS
%
% 
% Attribution
% -----------------------------------------------------
% Created by: Bradley Monk
% email:      brad.monk@gmail.com
% website:    bradleymonk.com
% updated:    2016.08.04
%
% 
% Potentially Helpful Resources and Documentation
% -----------------------------------------------------
% General brad code resources:
%     > http://bradleymonk.com/MATLAB
%     > https://github.com/subroutines
%
% Info related to this function/script:
%     > <a href="matlab: 
% web(fullfile(docroot, 'matlab/creating_plots/capturing-mouse-clicks.html'))">capturing-mouse-clicks</a>
%     > <a href="matlab: 
% web(fullfile(docroot, 'images/roi-based-processing.html'))">roi-based-processing</a>
%
% For more information, see the <a href="matlab: 
% web('http://bradleymonk.com/MATLAB/')">online documentation</a>.
%
%   See also imfreehand, impoly, imroi, poly2mask, inpolygon.


%% -- DEAL ARGS

    if nargin < 1
        % 0 INPUTS DEFAULTS TO CURRENT AXIS
    
        ax = gca;
        axP = get(gca,'Position');
        v2=1; v3=-1;

    elseif nargin == 1
        % 1st INPUT SPECIFIES AXIS (1 == USE CURRENT AXIS);
        v1 = varargin{1};
        
            if v1==1;
                ax = gca;
            else
                ax = v1;
            end
        v2=1; v3=-1;

    elseif nargin == 2
        % 2nd INPUT SPECIFIES LINE (1 |DEFAULT) OR SPLINE (2)
        [v1, v2] = deal(varargin{:});

            if v1==1;
                ax = gca;
            else
                ax = v1;
            end
         v3=-1;

    elseif nargin == 3
        % 3rd INPUT SPECIFIES WHETHER TO KEEP (-1 |DEFAULT) OR DELETE (0)
        % THE LINE POLYGON; ANY OTHER POSITIVE NUMBER INPUT (e.g. 1.5)
        % IN THIS ARG POSITION WILL DELETE THE POLYGON AFTER A PAUSE 
        % OF THAT LENGTH (e.g. pause(1.5) )
        [v1, v2, v3] = deal(varargin{:});

            if v1==1;
                ax = gca;
            else
                ax = v1;
            end

    else

        warning('Too many inputs')

    end

    
    
    
if verLessThan('matlab', '8.4.0')
%% ------------ FOR VERSIONS OF MATLAB AFTER 2014b ------------


    % -- CREATE SOME AXES TO DRAW ON
    ax1 = axes('Position',ax.Position,'Color','none',...
                'XLim',ax.XLim,'YLim',ax.YLim);
        hold on
    ax2 = axes('Position',ax.Position,'Color','none',...
                'XLim',ax.XLim,'YLim',ax.YLim);
        hold on


    % -- LOOP OVER ginput(1) -- SAVE POINTS -- PLOT LINE
    xx = [];
    yy = [];
    n = 0;
    but1 = 1;

    disp('Use the RIGHT MOUSE button to click on points.')
    disp('Use the LEFT MOUSE button to click LAST point.')
    while but1 == 1
        [xi,yi,but1] = ginput(1);

        plot(xi,yi,'ro','Parent',ax1)
        hold on

       n = n+1;

        xx(n) = xi;
        yy(n) = yi;
        line(xx,yy,'Parent',ax1)
        hold on

    end

    % -- CLOSE THE POLYGON AND PLOT
        n = n+1;
        xx(n) = xx(1);
        yy(n) = yy(1);
        line(xx,yy,'Parent',ax1)
        hold on

    % -- STORE OUTPUT VARIABLE XY COORDINATES FOR CLOSED POLYGON
        xy = [xx;yy]; 


    % -- INTERPOLATE (OR NOT) A SPLINE CURVE
    if v2 == 2
        t = 1:n;
        ts = 1: 0.1: n;
        xys = spline(t,xy,ts);

        ax1.delete
        plot(xys(1,:),xys(2,:),'b-','Parent',ax2);
        drawnow
    end


    % -- DELETE (OR NOT) THE DRAWN POLYGON
    if v3 >= 0
        pause(v3)
        ax1.delete
        ax2.delete
    end

else
%% ------------ FOR VERSIONS OF MATLAB BEFORE 2014b ------------

    % -- CREATE SOME AXES TO DRAW ON 

    position = get(ax, 'Position'); 
    xLim = get(ax, 'XLim'); 
    yLim = get(ax, 'YLim'); 
    ax1 = axes('Position',position,'Color','none',... 
    'XLim',xLim,'YLim',yLim); 
    hold on 
    position = get(ax, 'Position'); 
    xLim = get(ax, 'XLim'); 
    yLim = get(ax, 'YLim'); 
    ax2 = axes('Position',position,'Color','none',... 
    'XLim',xLim,'YLim',yLim); 
    hold on 



    % -- LOOP OVER ginput(1) -- SAVE POINTS -- PLOT LINE
    xx = [];
    yy = [];
    n = 0;
    but1 = 1;

    disp('Use the RIGHT MOUSE button to click on points.')
    disp('Use the LEFT MOUSE button to click LAST point.')
    while but1 == 1
        [xi,yi,but1] = ginput(1);

        plot(xi,yi,'ro','Parent',ax1)
        hold on

       n = n+1;

        xx(n) = xi;
        yy(n) = yi;
        line(xx,yy,'Parent',ax1)
        hold on

    end

    % -- CLOSE THE POLYGON AND PLOT
        n = n+1;
        xx(n) = xx(1);
        yy(n) = yy(1);
        line(xx,yy,'Parent',ax1)
        hold on

    % -- STORE OUTPUT VARIABLE XY COORDINATES FOR CLOSED POLYGON
        xy = [xx;yy]; 


    % -- INTERPOLATE (OR NOT) A SPLINE CURVE 
    if v2 == 2 
        t = 1:n; 
        ts = 1: 0.1: n; 
        xys = spline(t,xy,ts); 


        delete(ax1); 
        plot(xys(1,:),xys(2,:),'b-','Parent',ax2); 
        drawnow 
    end

    % -- DELETE (OR NOT) THE DRAWN POLYGON 
    if v3 >= 0 
        pause(v3) 

        if v2 == 1 
        delete(ax1); 
        else 
        delete(ax2) 
        end 

    end    
    
end


end
%%EOF