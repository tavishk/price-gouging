% This script assumes that you are using a 10x10 grid and that the 
% difference between supply and demand will fall within the range of  
% [-10,10]. Declaring more extreme values for init_supp, std_dmnd, and
% pnc_dmnd may result in errors in the visual output.

init_supp = ones(10)*6; % Supply array (default 6)
std_dmnd = randi([0 11],10); % Demand array (default range 0-11)
pnc_dmnd = std_dmnd + 5; % Simulate panic levels of demand by adding 5

std_price = sell(init_supp,std_dmnd,'Standard Scenario');
pnc_price = sell(init_supp,pnc_dmnd,'Panic Buying/Hoarding Scenario');

function new_price = sell(supply,demand,name)

% Simple difference in supply and demand will be used in the first
% grid that shows both shortages and surpluses
sale = supply - demand; 
% Derives a second array from sale that only contains surpluses
salevis = sale .* (sale > 0);

% Create an artificial demand curve by dividing the original quantity
% demanded by the quantity supplied. This is not meant to reflect any
% specific real world demand curve, it simply establishes an inverse 
% relationship between price and demand.
new_price = demand ./ supply;
% Set a price floor of $1
new_price(new_price < 1) = 1;

% Change price array to string array and separate indices for shortages
price_str = cur2str(reshape(new_price',[100,1]));
red_price = find(reshape(new_price',[100,1])>1);
black_price = find(reshape(new_price',[100,1])==1);

% Create colorbar
redgreen = zeros(21,3);
redgreen(1:11,1) = 1;
redgreen(1:11,2) = 0:.1:1;
redgreen(1:11,3) = 0:.1:1;
redgreen(11:21,2) = 1;
redgreen(11:21,1) = 1:-.1:0;
redgreen(11:21,3) = 1:-.1:0;

% These coordinates will be used to correctly center prices in the grid
[x,y] = find(ones(10));
x = x + .22;
y = y + .5;
z = ones(100,1)*-20;

figure('Name',name)
% tiledlayout is the successor to the subplot function and requires
% MATLAB 2019b or newer
t = tiledlayout(1,3,'TileSpacing','none','Padding','compact');
title(t,name)

set(gcf,'OuterPosition',[-5 110 2100 755])
nexttile
surf(padarray(sale,[1 1],0,'post'))
campos([6 6 -30])
colormap(redgreen)
colorbar('westoutside')
caxis([-10 10])
axis off
title('Surplus and Shortage')

nexttile
surf(padarray(salevis,[1 1],0,'post'))
campos([6 6 -30])
colormap(redgreen)
caxis([-10 10])
axis off
title('Information with Fixed Prices')
text(x,y,z,'$1.00')

nexttile
surf(padarray(salevis,[1 1],0,'post'))
campos([6 6 -30])
colormap(redgreen)
caxis([-10 10])
axis off
title('Information with Market Prices')
text(x(black_price),y(black_price),z(black_price),'$1.00')
text(x(red_price),y(red_price),z(red_price),price_str(red_price,:),...
    'Color','red')
end