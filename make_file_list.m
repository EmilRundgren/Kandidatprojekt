% function file_list = make_file_list(path, fmt)
%
% This function creates a file list using ls and returns the result as a
% cell array of tile names
% INPUT:
% path                file path to search
% fmt                 format string to find, such as '*.png', 'a*.txt'
%
% OUTPUT:
% file_list           cell array of file names matching format string
%
% Marcus Wallenberg, 2011-2014
function file_list = make_file_list(path, fmt)

%get all files of fmt
disp(['Executing: dir ' path '/' fmt])
try
    a = dir([path '/' fmt]);
catch me
    disp('Failed to find any files');
    file_list = {};
    return;
end

% with dir(), paths are not included
file_list = cell(size(a));
for k=1:numel(file_list)
    file_list{k} = [path '/' a(k).name];
end

disp([num2str(numel(file_list)) ' files found.']);