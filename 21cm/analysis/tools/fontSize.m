function [] = fontSize( size )
%fontSize resets all fonts on the current figure to size.

%get handles of all objects with the FontSize property
handles = findall(gcf,'-property','FontSize');

%set their FontSize to size
for i=1:length(handles)
    set(handles(i),'FontSize',size)
end

end