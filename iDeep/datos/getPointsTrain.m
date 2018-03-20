function [img, layer]=getPointsTrain(image,layer_end,img,layer)
image_aux = image;
%imagesc(imagenes(:,:,1));
aux = ones(32,217)*38;
aux2 = ones(245,32)*38;
image = [aux; image; aux];
image = [aux2,image,aux2];
aux = ones(32,217)*0;
aux2 = ones(245,32)*0;
layer_end_aux = [aux; layer_end; aux];
layer_end_aux = [aux2, layer_end_aux, aux2];
imagesc(image);
colormap(gray);
[y, x] = getpts;
%img = [];
%layer = [];
for i = 1:1:length(x)
  x_cord = round(x(i));
  y_cord = round(y(i)); 
  if((x_cord-15 > 0) && (x_cord+16 < 217) && (y_cord-15 > 0) && (y_cord+16 < 181))
      img = cat(4,img,image(x_cord-15:x_cord+16,y_cord-15:y_cord+16));
      layer = [layer, 0]; 
  end  
end
x = [];
y = [];
imagesc(image); 
colormap(gray);
[x, y] = getpts;
for i = 1:1:length(x)
  x_cord = round(x(i));
  y_cord = round(y(i));
  if((x_cord-15 > 0) && (x_cord+16 < 217) && (y_cord-15 > 0) && (y_cord+16 < 181))
      img = cat(4,img,image(x_cord-15:x_cord+16,y_cord-15:y_cord+16));
      layer = [layer, 1]; 
  end
end
size(img);
% Entrenamos la red
[net,train]=trainCNN(img,layer);
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
aux = ones(47,185);
clasifi = [aux; clasifi; aux];
aux = ones(245,48);
clasifi = [aux clasifi aux];
clasifi = imfuse(clasifi,image);
subplot(1,3,1);
imagesc(clasifi);
%imcontour(clasifi);
clases = categorical(single(sub1));
%imagesc(clasifi(:,:,2));
layer_end_aux = layer_end_aux == 0;
subplot(1,3,2);
imagesc(layer_end_aux);
clasifi(:,:,2)
clasifi(:,:,2) = clasifi(:,:,2) < 38;
subplot(1,3,3);
imagesc(clasifi(:,:,2));
layer_end_aux = layer_end_aux == clasifi(:,:,2);
layer_end_aux = sum(layer_end_aux);
sums = sum(layer_end_aux);
accuracy = sums/(245*281)
%accuracy = sum(predictedLabels == clases)/numel(clases)
%getPointsTrainNet(image_aux,layer_end,net);
end