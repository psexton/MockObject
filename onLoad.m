function onLoad()
%ONLOAD Add the src directories to the MATLAB path
  srcDir = fullfile(fileparts(mfilename('fullpath')), 'src');
  addpath(srcDir, '-end');
  addpath(fullfile(srcDir, 'mockobject'), '-end');
end
