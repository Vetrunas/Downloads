function Vetrunas_namu_darbas(arg1,arg2,arg3)

persistent h minefield cntmines rows cols t nummines remaining
persistent HEIGHT WIDTH BWIDTH BHEIGHT textHndl
persistent flagHndl bomb hidden flag hb nhb hflag

if nargin < 1,
   arg1 = 'start';
end;

if strcmp(arg1,'start') ;
   rows = 10;             
   cols = 10;             
   nummines = 18;        
   
   BWIDTH = 35;
   SWIDTH = 0;
   BHEIGHT = 35;
   SHEIGHT = 0;
   WIDTH = BWIDTH + SWIDTH;
   HEIGHT = BHEIGHT + SHEIGHT;
   
   bomb = [
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1
      1 1 1 2 1 1 2 2 2 2 2 1 1 2 1 1 1 1
      1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1
      1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1
      1 1 1 2 2 2 1 1 2 2 2 2 2 2 1 1 1 1
      1 1 1 2 2 2 1 1 2 2 2 2 2 2 1 1 1 1
      1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1
      1 1 1 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1
      1 1 1 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1
      1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1
      1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1
      1 1 1 2 1 1 2 2 2 2 2 1 1 2 1 1 1 1
      1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      ];
   
   hidden = bomb + 2*(bomb == 1);        
   
   flag = [
      3 3 3 3 3 3 2 3 3 3 3 3
      3 3 3 3 3 1 2 3 3 3 3 3
      3 3 3 1 1 1 2 3 3 3 3 3
      3 1 1 1 1 1 2 3 3 3 3 3
      3 3 3 1 1 1 2 3 3 3 3 3
      3 3 3 3 3 1 2 3 3 3 3 3
      3 3 3 3 3 3 2 3 3 3 3 3
      3 3 3 3 3 3 2 3 3 3 3 3
      3 3 3 3 3 3 2 3 3 3 3 3
      3 3 3 3 3 2 2 2 3 3 3 3
      3 3 3 3 2 2 2 2 2 3 3 3
      3 3 3 2 2 2 2 2 2 2 3 3
      ];
   
   xoff = 45;
   
   pos = get(0,'DefaultFigurePosition');
   figure('Name','Vetrunas_namu_darbas','NumberTitle','off',...
      'Resize','off',...
      'Visible','off',...
      'Color',192/255*[1 1 1], ...
      'WindowButtonDownFcn','Vetrunas_namu_darbas(''windowbuttondownfcn'')',...
      'WindowButtonUpFcn','Vetrunas_namu_darbas(''windowbuttonupfcn'')');
   colormap([1 0 0;0 0 0;.65 .65 .65;1 1 1]);    
   
   a = axes('Units','pixels',...
      'PlotBoxAspectRatio',[1 1 1],...
      'Position',[WIDTH+xoff,HEIGHT,cols*WIDTH-SWIDTH,rows*HEIGHT-SHEIGHT],...
      'Color','none',...
      'Box','on', ...
      'XLim',[0 cols*WIDTH-SWIDTH],...
      'YLim',[0 rows*HEIGHT-SHEIGHT], ...
      'XColor','k','YColor','k',...
      'YDir','reverse', ...
      'Tag','mainaxes', ...
      'Xtick',[],'Ytick',[]);
   hold on;      
   
   h = gobjects(rows,cols);         
   t = gobjects(rows,cols);         
   hflag = gobjects(rows,cols);     
   for m = 1:rows
      for n = 1:cols
         h(m,n) = uicontrol('Style','Pushbutton',...
            'Units','pixels',...
            'Position',[n*WIDTH+xoff,m*HEIGHT,BWIDTH,BHEIGHT],...
            'UserData',[m,n]);     
      end
   end
   nhb = 0;                       
   
   for m = 1:rows
      line('XData',[0,cols*WIDTH],'YData',[m*HEIGHT m*HEIGHT],...
         'Color','k','LineWidth',1);
   end
   for n = 1:cols
      line('XData',[n*WIDTH,n*WIDTH],'YData',[0,rows*HEIGHT],...
         'Color','k','LineWidth',1);
   end
   
   textHndl = uicontrol('Style','text',...
      'BackgroundColor',192/255*[1 1 1], ...
      'Units','pixels',...
      'FontSize',24, ...
      'FontWeight','bold', ...
      'Position', [WIDTH+xoff (rows+2)*HEIGHT 2*WIDTH WIDTH],...
      'String',num2str(nummines));
   
   
   yInitPos = 0.90;
   top = 0.95;
   left = 0.80;
   bottom = 0.05;
   btnWid = 0.15;
   btnHt = 0.10;
   spacing = 0.04;
   
   frmBorder = 0.02;
   yPos = 0.05-frmBorder;
   frmPos = [left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
   uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',frmPos, ...
      'BackgroundColor',[0.50 0.50 0.50]);
   
   btnNumber = 1;
   yPos = top-(btnNumber-1)*(btnHt+spacing);
   labelStr = getString(message('MATLAB:demos:shared:LabelFlag'));
   callbackStr = '';
   
   btnPos = [left yPos-btnHt btnWid btnHt];
   flagHndl = uicontrol( ...
      'Style','checkbox', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr, ...
      'BackgroundColor',[0.50 0.50 0.50]);
   
   btnNumber = 2;
   yPos = top-(btnNumber-1)*(btnHt+spacing);
   labelStr = getString(message('MATLAB:demos:shared:LabelNew'));
   callbackStr = 'Vetrunas_namu_darbas(''newgame'')';
   
   btnPos = [left yPos-btnHt btnWid btnHt];
   uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   labelStr = getString(message('MATLAB:demos:shared:LabelInfo'));
   callbackStr = 'xpbombs(''info'')';
   infoHndl = uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   
   labelStr = getString(message('MATLAB:demos:shared:LabelClose'));
   callbackStr = 'close(gcf)';
   closeHndl = uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left bottom btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   set(gcf, ...
      'Visible','on', ...
      'Color',192/255*[1 1 1]);  
   
   Vetrunas_namu_darbas('newgame');
   
elseif strcmp(arg1,'newgame'),
   axes(findobj(gcf,'Tag','mainaxes'));
   
   remaining = nummines;
   set(textHndl,'String',num2str(remaining));
   
   minefield = rand(rows,cols);
   [temp,index] = sort(minefield(:));
   minefield = (minefield <= minefield(index(nummines)));
   
   
   east = (2:cols);
   west = (1:cols-1);
   north = (1:rows-1);
   south = (2:rows);
   cntmines = zeros(rows,cols);
   cntmines(:,west) = cntmines(:,west) + minefield(:,east);
   cntmines(:,east) = cntmines(:,east) + minefield(:,west);
   cntmines(north,:) = cntmines(north,:) + minefield(south,:);
   cntmines(south,:) = cntmines(south,:) + minefield(north,:);
   cntmines(north,west) = cntmines(north,west) + minefield(south,east);
   cntmines(north,east) = cntmines(north,east) + minefield(south,west);
   cntmines(south,west) = cntmines(south,west) + minefield(north,east);
   cntmines(south,east) = cntmines(south,east) + minefield(north,west);
   
   for i = 1:nhb         
      delete(hb(i))
   end
   nhb = 0;
   
   for m = 1:rows
      for n = 1:cols
         set(h(m,n),'Visible','on','Callback','Vetrunas_namu_darbas(''buttondown'')');
         if t(m,n) ~= 0            
            delete(t(m,n));
            t(m,n) = gobjects(1) ;
         end
         if hflag(m,n) ~= 0        
            delete(hflag(m,n));
            hflag(m,n) = gobjects(1);
         end
      end
   end
   
   set(flagHndl,'Value',0);      
   set(gcf,'Color',192/255*[1 1 1]);
   title('Minuslavejas')
elseif strcmp(arg1,'buttondown')
   
   axes(findobj(gcf,'Tag','mainaxes'));
   
   userdata = get(gco,'UserData');
   m = userdata(1);
   n = userdata(2);
   
   if get(flagHndl,'Value') == 1         
      if strcmp(get(h(m,n),'Visible'),'on')
          hflag(m,n) = image([(n-1)*WIDTH+4,(n-1)*WIDTH+2+BWIDTH-5],...
              [(rows-m)*HEIGHT+4,(rows-m)*HEIGHT+2+BHEIGHT-5],flag);
          set(h(m,n),'Visible','off');        
          remaining = remaining - 1;
          set(textHndl,'String',num2str(remaining));
          drawnow
      end
      
   else
      if minefield(m,n)   
         nhb = 1;
         hb(nhb) = image([(n-1)*WIDTH+2,(n-1)*WIDTH+2+BWIDTH-2],...
            [(rows-m)*HEIGHT+2,(rows-m)*HEIGHT+2+BHEIGHT-2],bomb);
         set(h(m,n),'Visible','off');      
         set(gcf,'Color','r');             
         drawnow;
         set(gcf,'Color','k');
         drawnow;
         for i = 1:rows                    
            for j = 1:cols
               set(h(i,j),'CallBack','');    
               if minefield(i,j) && (i ~= m || j ~= n)
                  nhb = nhb + 1;
                  hb(nhb) = image([(j-1)*WIDTH+2,(j-1)*WIDTH+2+BWIDTH-2],...
                     [(rows-i)*HEIGHT+2,(rows-i)*HEIGHT+2+BHEIGHT-2],...
                     hidden);
                  set(h(i,j),'Visible','off');
               end
            end
         end
      else
         Vetrunas_namu_darbas('uncover',m,n);
      end;
   end
   
elseif strcmp(arg1,'windowbuttondownfcn')
   
   axes(findobj(gcf,'Tag','mainaxes'));
   
   if get(flagHndl,'Value') == 1
      pt = get(gca,'CurrentPoint');
      m = rows - (floor(pt(1,2) / HEIGHT) + 1) + 1;
      n = floor(pt(1,1) / WIDTH) + 1;
      if 1 <= m && m <= rows && 1 <= n && n <= cols
         if hflag(m,n) ~= 0
            set(h(m,n),'Visible','on');
            delete(hflag(m,n));
            hflag(m,n) = gobjects(1);
            remaining = remaining + 1;
            set(textHndl,'String',num2str(remaining));
         end
      end
      drawnow;
   end
   
elseif strcmp(arg1,'uncover')
   axes(findobj(gcf,'Tag','mainaxes'));
   m = arg2;
   n = arg3;
   if strcmp(get(h(m,n),'Visible'),'on')
      set(h(m,n),'Visible','off');
      c = cntmines(m,n);
      if c > 0
         t(m,n) = text('Units','pixels',...
            'Position',[(n-0.5)*WIDTH,(m-0.5)*HEIGHT],...
            'FontSize',18,...
            'HorizontalAlignment','center');
         if c == 1
            set(t(m,n),'String',num2str(c),'Color','r');
         elseif c == 2
            set(t(m,n),'String',num2str(c),'Color','b');
         elseif c == 3
            set(t(m,n),'String',num2str(c),'Color','g');
         elseif c == 4
            set(t(m,n),'String',num2str(c),'Color','y');
         elseif c == 5
            set(t(m,n),'String',num2str(c),'Color','c');
         elseif c == 6
            set(t(m,n),'String',num2str(c),'Color','m');
         elseif c == 7
            set(t(m,n),'String',num2str(c),...
               'Color',[1,.6471,0]);               
         elseif c == 8
            set(t(m,n),'String',num2str(c),...
               'Color',[.8588,.5098,.8588]);       
         end
      else        
         if m > 1
            if n > 1, Vetrunas_namu_darbas('uncover',m-1,n-1), end;
            Vetrunas_namu_darbas('uncover',m-1,n);
            if n < cols, Vetrunas_namu_darbas('uncover',m-1,n+1), end;
         end
         if n > 1, Vetrunas_namu_darbas('uncover',m,n-1), end;
         if n < cols, Vetrunas_namu_darbas('uncover',m,n+1), end;
         if m < rows
            if n > 1, Vetrunas_namu_darbas('uncover',m+1,n-1), end;
            Vetrunas_namu_darbas('uncover',m+1,n);
            if n < cols, Vetrunas_namu_darbas('uncover',m+1,n+1), end;
         end
      end
   end
   
elseif strcmp(arg1,'info')
   helpwin(mfilename);
   
end 


