function [C,h] = map_outline(template,longi,lati)

    template(~isnan(template) == 1) = 1;
    template(isnan(template) == 1) = 0;
    [C,h] = contour(longi,lati,template.','black');
    set(h, 'LineWidth',0.1);
end