#!/bin/bash

# Loop through each subject directory
for subject_dir in */; do
  missing_folders=""
  
  # Check if 'anat' directory is present
  if [ ! -d "${subject_dir}anat" ]; then
    missing_folders="anat"
  fi
  
  # Check if 'func' directory is present
  if [ ! -d "${subject_dir}func" ]; then
    if [ -z "$missing_folders" ]; then
      missing_folders="func"
    else
      missing_folders="${missing_folders}, func"
    fi
  fi
  
  # If there are any missing folders, print the subject directory and missing folders
  if [ ! -z "$missing_folders" ]; then
    echo "${subject_dir} is missing: ${missing_folders}"
  fi
done
