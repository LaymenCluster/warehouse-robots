function [stop, goal, reached, collide, r2] = check_collision(position, bot_final, bots, not_detected)

goal = bot_final;
r2 = bot_final;
stop = zeros([1, length(bots)]);
collide = zeros([1, length(bots)]);
reached = zeros([1, length(bots)]);

% adjust values when camera is repositioned
radius1 = 60; % minimum distance to completely stop bot's inevitable collision
radius2 = 100; % minimum distance to re-route bots
radius3 = 40; % minimum distance to check if goal is reached

for i = 1:length(bots)
    for j = 1:length(bots)
        if i~=j && ~ismember(bots(i),not_detected) && ~ismember(bots(j),not_detected)
            stop(i) = stop(i) + (norm(position(i,:)-position(j,:)) < (radius1));
            collide(i) = collide(i) + (norm(position(i,:)-position(j,:)) < (radius2));
        end
    end
    if ~ismember(bots(i),not_detected)
        reached(i) = norm(bot_final(i,:)-position(i,:)) < (radius3);
    end
end

%avoid obstacles using vectors

for i = 1:length(bots)
    r1 = [0 0];
    for j = 1:length(bots)
        if i~=j && (norm(position(i,:)-position(j,:)) < (radius2)) && ~ismember(bots(i),not_detected) && ~ismember(bots(j),not_detected)
            a = (position(j,:) - position(i,:))/norm(position(j,:) - position(i,:));
            r1 = r1 + a;
            r1 = r1/norm(r1);
        end
    end
    if collide(i) && ~ismember(bots(i),not_detected)
        r1 = -r1;
        theta = 80;
        goal(i,:) = [(r1(1,1)*cos(deg2rad(theta))-r1(1,2)*sin(deg2rad(theta))) (r1(1,1)*sin(deg2rad(theta))+r1(1,2)*cos(deg2rad(theta)))];
        goal(i,:) = goal(i,:)/norm(goal(i,:));
        goal(i,:) = 130*goal(i,:)+position(i,:);
        r2(i,:)=130*r1+position(i,:);
    end
end

end
