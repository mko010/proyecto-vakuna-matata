function [sub, subl]=getData2(image,layer)
  sub = [];
  subl = [];
  [r w] = size(image);
  index = 2;
  for i = 1:2:(r-32)
    for j = 1:2:(w-32)
      sub = cat(4,sub,image(i:i+31,j:j+31));      
      subl = [subl layer(i+16,j+16)];
      index = index +1;
    end
  end  
end