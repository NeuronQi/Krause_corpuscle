function [newx, newy] = makeline(line1, line2, sampleNum)
% line 1 connects two points, [x1, y1] to [x2, y2];
% line 2 connects another two points, [x3, y3] to [x4, y4];
% sampleNum is the number of lines to creat between line 1 and line2
% format of line1 should be [x1, x2, y1, y2];
% format of line2 should be [x3, x4, y3, y4]; 
newx = zeros(sampleNum, 2);
newy = zeros(sampleNum, 2);
newx(:,1) = linspace(line1(1), line2(1), sampleNum);
newy(:,1) = linspace(line1(3), line2(3), sampleNum);
newx(:,2) = linspace(line1(2), line2(2), sampleNum);
newy(:,2) = linspace(line1(4), line2(4), sampleNum);
end
