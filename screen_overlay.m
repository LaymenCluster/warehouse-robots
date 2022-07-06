function [I] = screen_overlay(I, position, frames, path, bot_final, goal, bots, not_detected,r1)

a=10;
radius1 = 50;

for i = 1:length(bots)
    if ~ismember(bots(i),not_detected)
        markerPosition = [position(i,:),radius1];
        I = insertShape(I, 'Circle', markerPosition, "Color", "blue", 'LineWidth', 5);
        I = insertShape(I, 'FilledCircle', [goal(i,:), 8], "Color", "red");
        I = insertShape(I, 'FilledCircle', [r1(i,:), 8], "Color", "green");
        I = insertShape(I, 'FilledCircle', [bot_final(i,:), 8], "Color", "blue");
        I = insertShape(I, 'Line', path(i,:), "Color", "blue", 'LineWidth', 5);
        I = insertText(I, position(i,:), bots(i), "BoxOpacity" , 1, "FontSize", 20);
        I = insertText(I, goal(i,:)+8, bots(i), "BoxOpacity", 1, "FontSize", 20);
        I = insertText(I, r1(i,:)+8, bots(i), "BoxOpacity", 1, "FontSize", 20);
        I = insertText(I, bot_final(i,:)+8, bots(i), "BoxOpacity", 1, "FontSize", 20);
    else
        I = insertText(I, [560,a], "BOT "+ bots(i) +" NOT DETECTED", "BoxOpacity", 1, "FontSize", 20);
        a = a + 40;
    end
end

I = insertText(I, [10,10], frames, "BoxOpacity", 1, "FontSize", 20);

end
