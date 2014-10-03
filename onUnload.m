function onUnload()
%ONUNLOAD Remove the src directories from the MATLAB path
  srcDir = fullfile(fileparts(mfilename('fullpath')), 'src');
  rmpath(srcDir);
  rmpath(fullfile(srcDir, 'mockobject'));
end
