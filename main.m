clc
clear
close all

%%
% set information of bots

bots = [1 2 3];
% replace asterisks with ip address of robots
bot_address = ["***.***.***.***", "***.***.***.***", "***.***.***.***"];
bot_final = [150 400; 400 500;650 400];
inst = zeros([2, length(bots)]);

% replace asterisks with ip address of ip web cam on smartphone
camera = ipcam('http://***.***.***.***:8080/video');
u=udpport("IPV4");
frames=0;
path = zeros([length(bots),4]);

I = snapshot(camera);
[position, angle, not_detected] = detection_apriltag(I, bots);
imshow(I)
[stop, goal, reached, collide, r1] = check_collision(position, bot_final, bots, not_detected);

%%
% looping until all bots reached their final positions

while sum(~reached)

    [stop, goal, reached, collide, r1] = check_collision(position, bot_final, bots, not_detected);
    
    for i = 1:length(bots)
        if ~stop(i) && ~reached(i) && ~ismember(bots(i),not_detected)

            % Compute the controller outputs, i.e., instructions to the robot
            [steering, theta] = own_controller(goal(i,:), position(i,:), angle(i));
            omega = num2str(steering);
            if theta < 90 && theta > -90
                writeline(u, '4', bot_address(i), 4210);
                inst(1,i) = 4;
            else
                writeline(u, '5', bot_address(i), 4210);
                inst(1,i) = 5;
            end
            writeline(u, omega, bot_address(i), 4210);
            inst(2,i) = steering;

            % generating paths
            path(i,:) = [position(i,:), bot_final(i,:)];
        end
    end

    pause(0.08);
    for i = 1:length(bots)
        writeline(u, '3', bot_address(i), 4210);
    end

    %capturing a frame from video and getting location of bots
    I = snapshot(camera);
    [position, angle, not_detected] = detection_apriltag(I, bots);

    % display text and graphical information on figure
    I = screen_overlay(I, position, frames, path, bot_final, goal, bots, not_detected,r1);
    frames = frames+1;
    imshow(I)
    hold on

    reached = [1 1 1];
    inst
end

%%
%stop bots

for i = 1:length(bots)
    writeline(u, '3', bot_address(i), 4210);
end



