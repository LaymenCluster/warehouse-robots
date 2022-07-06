function [steering, theta] = own_controller(currentGoal, currentPosition, currentOrientation)

% Orientation with respect to image
%
%        270
%         |
% 180 <---:---> 0
%         |
%         90

angle1 = (atan2(currentGoal(2)-currentPosition(2), currentGoal(1)-currentPosition(1))) * 180/pi;
if angle1 < 0
    angle1 = angle1 + 360;
end

theta = angle1 - currentOrientation;
if (angle1 >= 0) && (angle1 <= 180) && (theta < -180)
    theta = theta + 360;
end
if (angle1 > 180) && (angle1 <= 360) && (theta > 180)
    theta = theta - 360;
end

if theta > 8 && theta < 172
    steering = 1;   % left wheel
elseif theta < -8 && theta > -172
    steering = 2;   % right wheel
else
    steering = 0;   % forward
end

end
