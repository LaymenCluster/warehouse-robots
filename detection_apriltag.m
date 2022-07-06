function [position, angle, not_detected] = detection_apriltag(I, bots)

% Orientation with respect to image
%
%        270
%         |
% 180 <---:---> 0
%         |
%         90

[id,loc] = readAprilTag(I,"tag36h11");
position = nan(length(bots), 2);
angle = nan(1, length(bots));
for i = 1:length(id)
    for j = 1:length(bots)
        if id(i)==bots(j) && ismember(id(i),bots)
            centroid = [sum(loc(:,1,i))/4, sum(loc(:,2,i))/4];
            position(j,:) = centroid;
            angle(j) = (atan2(loc(2,2,i)-loc(3,2,i), loc(2,1,i)-loc(3,1,i))+pi)*180/pi;
            if angle(j)<0
                angle(j) = angle(j)+360;
            end
        end
    end
end

not_detected = setxor(bots,id);
not_detected = intersect(bots,not_detected);

end
