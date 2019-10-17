global N;
global points; points = 500;
global ws;
%            left                   centre                 right
%               _____________________________________________ 
%              |                                             |
%              |                                             |
%              |                                             |
%______________|_____________________________________________|_____________
%             0.2                  diapason                 0.8

ws = sortByDiff(nchoosek((0.2:0.01:0.8),2));%from 0.2 to 0.8 with step 0.05 Count = 78;
str = ws;
N = size(ws,1);
%ws = filtRange(ws,0.05);
target = GetStrip([0.2, 0.3],'bs'); amplifier(points,size(ws,1)) = 0; phase(points,size(ws,1)) = 0;
for i = 1: size(ws,1)
    
    [a, b, c] = GetButter(ws(i,:), 'bandpass');
    amplifier(:,i) = a;
    phase(:,i) = c;
end
figure; hold on;
subplot(2,1,1);
plot(linspace(0, 1 - (1/points), points), amplifier);
subplot(2,1,2);
plot(linspace(0, 1 - (1/points), points), phase);

%% get 3 target points, indexes: 1 - left point, 2 - centre point, 3 - right
for i = 1: size(ws,1)
   targetPoints(i,2) = GetCentrePoint(amplifier(:,i), "bandpass"); 
   targetPoints(i,1) = GetPoints(linspace(0, 1 - (1/points), points), ws (i,1));
   targetPoints(i,3) = GetPoints(linspace(0, 1 - (1/points), points), ws(i,2));
   local = phase(:,i);
   targetPoints(i,4) = GetPoints(local(11:points), max(local(11:points)))+10;
   targetPoints(i,5) = GetPoints(local(11:points), min(local(11:points)))+10;
end
%% get values
%amplifier
for i = 1: size(ws,1)
    for j = 1: size(targetPoints,2)
       ampValues(i,j) = amplifier(targetPoints(i,j),i);
       phaseValues(i,j) = phase(targetPoints(i,j),i);
    end
end
figure;
plot(phaseValues(:,1))
figure;
plot(phaseValues(:,3))
figure;
plot(phaseValues(:,4))
figure;
plot(phaseValues(:,5))
figure
plot(phaseValues(:,4)+phaseValues(:,5));
figure
plot([phaseValues(:,4),phaseValues(:,1)]);