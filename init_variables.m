function [] = init_variables()
global skarmStorlek skarmBredd skarmHojd ...
    mainscreenIndragHojd mainscreenIndragBredd mainscreenHojd mainscreenBredd mainscreenPosX mainscreenPosY ...
    knappBredd knappHojd ...
    previewMenuBredd previewMenuHojd previewMenuPosX previewMenuPosY ...
    fontStorlek

skarmStorlek = get(groot, 'ScreenSize');
skarmBredd = skarmStorlek(3);
skarmHojd = skarmStorlek(4);

% --- Startscreen ---


% --- Mainscreen ---
if (ismac)
mainscreenIndragHojd = 50;
mainscreenHojd = skarmHojd - mainscreenIndragHojd;
else
mainscreenIndragHojd = 10;
mainscreenHojd = skarmHojd - 2*mainscreenIndragHojd;
end
mainscreenIndragBredd = 50;
mainscreenBredd = skarmBredd - 2*mainscreenIndragBredd;

mainscreenPosX = mainscreenIndragBredd;
mainscreenPosY = 0;

% --- Knappar ---
knappBredd = 100;
knappHojd = 40;

% --- Förhandsgranskningsfönster ---
previewMenuBredd = skarmBredd*(3/5);
previewMenuHojd = skarmHojd*(9/10);
previewMenuPosX = skarmBredd/2 - previewMenuBredd/2;
previewMenuPosY = skarmHojd/3;

% --- Font ---
if (ismac)
    fontStorlek = 12;
else
    fontStorlek = 10;
end


