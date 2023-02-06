function [readValues] = readFromFile(fileToRead)

    fileID = fopen(fileToRead, 'r');
    formatSpec = '%f';
    readValues = fscanf(fileID, formatSpec);
    
return