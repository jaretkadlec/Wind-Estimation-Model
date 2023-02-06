function [] = writeToFile(arrayToWrite, fileToWrite)

    fileID = fopen(fileToWrite, 'w');
    fprintf(fileID,'%4.6f\n',arrayToWrite);
    fclose(fileID);
    
return
    
   
