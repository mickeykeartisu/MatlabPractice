function bendline(actionstr)

global maphandles xa fs


switch actionstr
  case 'initialize'
      maphandles=zeros(100);
	  maphandles(20)=1;
	  maphandles(21)=0;
	  maphandles(22)=0;
	  if isempty(fs)
		  fs=22050;
	  end;
	  mapmanipulate2
	  title('nonlinear frequency mapping controller');
	  xlabel('new frequency axis (normalized frequency)')
	  ylabel('original frequency axis (normalized frequency)')
	  bendline catalogue
  case 'resetbtn'
	  maphandles(20)=1;
	  maphandles(21)=0;
	  maphandles(22)=0;
 	  set(maphandles(4),'String','');
	  set(maphandles(5),'String','');
      bendline redrawline
  case 'move'
%    hh=findobj('Tag','Axes1Line1');
%    pt=get(gca,'currentpoint');
    hh=maphandles(2);
    pt=get(hh,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);
	xa=[0:0.01:1];
    hh=maphandles(3);
	if (abs(1-x)<0.05) | (abs(1-y)<0.05)
	  maphandles(20)=y/x;
    elseif (abs(0.5-x)<0.07)
	  maphandles(21)=y-maphandles(20)*0.5;
    elseif (abs(0.25-x)<0.05)
	  maphandles(22)=y-maphandles(20)*0.25-maphandles(21)*sin(pi*0.25);
    elseif (abs(0.75-x)<0.05)
	  maphandles(22)=-(y-maphandles(20)*0.75-maphandles(21)*sin(pi*0.75));
    end;
    bendline redrawline
	set(maphandles(4),'String',num2str(y*fs/2,6));
	set(maphandles(5),'String',num2str(x*fs/2,6));
  case 'redrawline'	
    hh=maphandles(3);
	xa=[0:0.01:1];
    set(hh,'Ydata',xa*maphandles(20)+sin(pi*xa)*maphandles(21)+ ...
	    sin(2*pi*xa)*maphandles(22));
  case 'down'
%	hh=findobj('Tag','bendlinemanipulator');
    hh=maphandles(1);
	set(hh,'WindowButtonMotionFcn','bendline move');
  case 'up'
%	hh=findobj('Tag','bendlinemanipulator');
    hh=maphandles(1);
	set(hh,'WindowButtonMotionFcn','');
  case 'closebtn'
	close(maphandles(1))
%-------------------------------------------------------------
%	Housekeeping for the first time
%-------------------------------------------------------------
case 'catalogue'
	maphandles(1)=findobj('Tag','bendlinemanipulator');
	maphandles(2)=findobj('Tag','mapaxis');
	maphandles(3)=get(maphandles(2),'UserData');
	maphandles(4)=findobj('Tag','ofqedit');
	maphandles(5)=findobj('Tag','newfqedit');
end;
