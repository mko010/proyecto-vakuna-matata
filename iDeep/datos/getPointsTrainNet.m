function getPointsTrainNet(image,layer_end,net)
image_aux = image;
%imagesc(imagenes(:,:,1));
aux = ones(32,217)*38;
aux2 = ones(245,32)*38;
image = [aux; image; aux];
image = [aux2,image,aux2];
size(image);
ylim([32 211]);
imagesc(image);

colormap(gray);
[y, x] = getpts;
img = [];
layer = [];
for i = 1:1:length(x)
  x_cord = round(x(i));
  y_cord = round(y(i));
  img = cat(4,img,image(x_cord-15:x_cord+16,y_cord-15:y_cord+16));
  layer = [layer, 0];
end
x = [];
y = [];
imagesc(image); 
colormap(gray);
[x, y] = getpts;
for i = 1:1:length(x)
  x_cord = round(x(i));
  y_cord = round(y(i));
  img = cat(4,img,image(x_cord-15:x_cord+16,y_cord-15:y_cord+16));
  layer = [layer, 1];
end
size(img);
% Entrenamos la red
[net]=trainCNNet(net,img,layer);
% Obtenemos todas las subimágenes de la matriz
[sub,sub1]=getData2(image_aux,layer_end);
size(sub)
clasifi = [];
for i = 1:1:6975
  predictedLabels = classify(net,sub(:,:,i));
  clasifi = [clasifi predictedLabels];
end
clasifi = reshape(clasifi,[93,75]);
clasifi = imresize(double(clasifi),[185 151]);
%clasifi = clasifi == 1;
clasifi = clasifi';
size(image)
size(clasifi)
aux = ones(47,185);
clasifi = [aux; clasifi; aux];
aux = ones(245,48);
clasifi = [aux clasifi aux];
clasifi = imfuse(clasifi,image);
imagesc(clasifi);
%imcontour(clasifi);
clases = categorical(single(sub1));
accuracy = sum(predictedLabels == clases)/numel(clases)
end