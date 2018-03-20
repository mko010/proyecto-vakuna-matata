function [sub,subl]=getData(images,layers)
  sub = [];
  subl = []; 
  size(images)
  for k = 1:1:65
    image = images(:,:,k);
    layer = layers(:,:,k);
    [r w] = size(image);
    for i = 1:1:(r-32)
      for j = 1:1:(w-32)
        sub = cat(4,sub,image(i:i+31,j:j+31));
        %sub(:,:,:,index) = image(i:i+31,j:j+31); 
        subl = [subl layer(i+16,j+16)];        
      end
    end
  end
  [r w] = size(sub);
  w/32
end