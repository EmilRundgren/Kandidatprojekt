function [] = init_variables()

skarmStorlek = get(groot, 'ScreenSize');
skarmBredd = skarmStorlek(3);
skarmHojd = skarmStorlek(4);

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


knappBredd = 100;
knappHojd = 40;
