function [handle] = createWindow(bredd, hojd, xPos, yPos, namn, text)
global knappHojd

f = figure('MenuBar','none');
set(f, 'Name', namn, 'NumberTitle', 'off');
set(f, 'Position', [xPos yPos bredd hojd]);

text = uicontrol(f, 'Style', 'text', 'string', {text}, ...
'pos', [bredd/4, hojd-1.5*knappHojd, bredd/2 knappHojd*(2/3)]);
set(text, 'FontSize', 25);
handle = gcf;