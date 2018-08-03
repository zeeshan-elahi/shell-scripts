#!/bin/sh
#####################################################
# Author: Zeeshan Elahi <zeeshan.elahi83@gmail.com> #
# Company: VIZE Solutions <www.vizesolutions.com>   #
#####################################################

usage="
#####################################################
# Author: Zeeshan Elahi <zeeshan.elahi83@gmail.com> #
# Company: VIZE Solutions <www.vizesolutions.com>   #
#####################################################

$(basename "$0") [--help] [-copy -src -file -dest] -- A small
     program to copy data from a compressed zip file to
     desired directory.


where:
   --help  Use to show help regarding 
           script arugments and usage.
    
    -copy  This argument is used to set name of corresponding
           folders that will be moved from source to
           destination directory.
           [Default is all = clutter, entity_images,exercise,
            models].
           If this argument is not provided program will
           automatically assume default value.
    
    -src  This argument is used to set path of source
          directory with compressed data file.
          e.g. /home/User/source.
          Please make sure to not add / at end of this
          argument.
          [Default value is current working directory
           with .sh file.]

    -file  This argument is used to set name of source
           compressed file. This should be a zip file.
           As program only accept this format. Program
           will terminate and throw error in case of any
           other file format.
           [Default value is data.zip.]

    -dest  This argument is used to set path of
           destination directory.
           e.g. /home/User/data.
           Pleae make sure to not add / at end of this
           argument.
           [Default value is destination/data directory in
            current working directory with .sh file.]

#################################################"

data_file_name="data.zip"
data_file_path="$PWD"
destination_directories="clutter,entity_images,exercise,models"
destination_data_path="$PWD/destination/data"
result="success"

#Check arguments passed to function
while [ "$1" != "" ]; do
  case $1 in
   --help)
      echo "$usage"
      exit
      ;;
    *)
      echo "This is limited version. It only work with default values."
      echo "Please contact with developer for complete version."
      echo "Please use \"sh $(basename "$0") --help\" to see list of available arguments"
      exit
      ;;
  esac
  shift
done

echo ""
echo "Starting script ..."
echo ""
data_file_path="$data_file_path/$data_file_name"
echo "Source path: $data_file_path"

echo ""
echo "Destination path: $destination_data_path"

echo ""
echo "Directories to copy: $destination_directories"
echo ""

if [ -a $data_file_path  ]
then
  echo "Data zip archive found in given/current directory."

  #Extract zip file to backup
  echo ""
  echo "Extracting $data_file_name ..."
  unzip $data_file_path -d "backup/" >&-

  if [ -d "backup/data" ]
  then
    echo ""
    echo "Data zip archive extracted successfully."

    SAVEIFS=$IFS

    IFS=',';
    arrIN=($destination_directories)
    for i in "${arrIN[@]}"; do
      current_source_path="backup/data/$i"
      current_destination_path="$destination_data_path/$i/"
      
      if [ -d $current_source_path ]
      then
        echo ""
        echo "Moving $current_source_path to $current_destination_path"
        mkdir -p "$current_destination_path/"
        cp -r $current_source_path/* $current_destination_path
        result="success"
      else
        echo ""
        echo "Source directory $current_source_path not found"
        result="error"
      fi
    done
    rm -rf backup/*
    IFS=$SAVEIFS

  else
    echo "Unable to extract data zip archive."
    result="error"
  fi
 
else
  echo "Data zip archive not found in given/current directory."
  result="error"
fi

echo ""
if [ "$result" = "success" ]
then
  echo "Script has been executed successfully."
else
  echo "Execution failed. An error has occurred."
fi
