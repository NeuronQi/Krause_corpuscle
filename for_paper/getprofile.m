function s = getprofile(folder, bfmatlabfolder)
%This function is to first load the ROIset file and czi file, then create
%sample lines between the ROI lines from ImageJ, then measure the intensity
%along the sample lines before averaging and saving in a structure

% input: 
% folder is where the ROIset and czi files are located
% bfmatlabfolder is where the bfmatlab files are located

% output: 
% s is a structure containing information about the intensity measurement

%% load thd ROIset file and the czi file
[ROIfilename,folder] = uigetfile([folder, filesep,'*.zip'], "choose the ROIset file for lines");
ROIfolder = fullfile(folder, ROIfilename(1:end-4));
mkdir(ROIfolder);
ROIfiles = unzip(fullfile(folder,ROIfilename),ROIfolder);

[cziFilename, ] = uigetfile([folder,filesep,'*.czi; *.tif'],...
    ['choose the czi file (Z projection) where ',ROIfilename,' is from']);

%% Read the size and scale of czi file
% addpath 'E:\Dropbox (HMS)\code\current_matlab'
addpath(bfmatlabfolder)
OMEData = GetOMEData(fullfile(folder,cziFilename)); % it's ok to have warnings
% Scale micron per pixel

d = bfopen(fullfile(folder,cziFilename));

%% Read the ROI file
nROI = numel(ROIfiles);
% Extract the line coordinates
x = zeros(nROI, 2);
y = zeros(nROI, 2);
for i = 1:numel(ROIfiles)
    [sROI] = ReadImageJROI(ROIfiles{i});
    x(i,:) = sROI.vnLinePoints([1, 3]);
    y(i,:) = sROI.vnLinePoints([2, 4]);    
end

figure,
imshow(d{1}{3,1},[]) % here is showing the 3rd channel of the image, 
% it can be changed to imshow(d{1}{2,1},[]) to show the 2nd channel and etc
hold on
for i = 1:nROI    
    line(x(i,:), y(i,:))
end
title("ROI lines")
%% Measure along the ROI lines
lineArray = uniprofile(d, x, y);
title("Measured intensity along the ROI lines")

%% Measure along Sample Lines evenly created between the ROI lines  

sampleNum = 100; % sampleNum is the number of sample lines created between the most left and most right lines
% get the number of sample lines between each ROI line
[xsort, ix] = sortrows(x); % B = A(index,:), so xsort = x(ix);
xdiff = diff(xsort(:,1));
xnorm = xdiff/sum(xdiff);
ngap = round(xnorm*sampleNum);
newxAll = []; 
newyAll = [];
for i = 1:numel(ngap)
    line1 = [xsort(i,:),y(ix(i),:)];
    line2 = [xsort(i+1,:), y(ix(i+1),:)];
    [newx, newy] = makeline(line1, line2, ngap(i)); % makeline is a custom function
    newxAll = [newxAll; newx];
    newyAll = [newyAll; newy];
end
% inspect the evenly distributed lines
figure,
imshow(d{1}{3,1},[])
hold on
for i = 1:sum(ngap)    
    line(newxAll(i,:), newyAll(i,:))
end
title("Sample lines evenly distributed among the ROI lines")
sampleArray = uniprofile(d,newxAll, newyAll); % uniprofile is a custom function
title("Average intensity along the sample lines")
%% Save into a structure
structName = fullfile(folder, "spinal_terminal.mat");
if isfile(structName)
    load(structName);
else
    s = struct;
end

fieldName = ROIfilename(1:end-4);
s.(fieldName).Scale = OMEData.ScaleX; % micron per pixel
s.(fieldName).x = x;
s.(fieldName).y = y;
s.(fieldName).newx = newxAll;
s.(fieldName).newy = newyAll;
s.(fieldName).lineIntensity = lineArray;
s.(fieldName).sampleIntensity = sampleArray;
save(structName,"s");

end