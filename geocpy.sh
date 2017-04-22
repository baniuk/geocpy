#!/bin/bash - 
#===============================================================================
#
#          FILE: geocpy.sh
# 
#         USAGE: ./geocpy.sh FOLDER
# 
#   DESCRIPTION: This small utility copies Geo tags from jpg files to
#                corresponding dng files. The main purpose is to add geo tags to
#                dng files saved by Samsung S7. These files always are
#                accompanied by jpg, which have geo tags.
# 
#       OPTIONS: FOLDER - folder with jpg and dng files
#  REQUIREMENTS: Intenet connection for downloading exiftool
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Piotr Baniukiewicz (baniuk), baniuk1@gmail.com
#  ORGANIZATION: 
#       CREATED: 21/04/17 21:52:21
#      REVISION: 1.0 - initial
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  prepareExifTool
#   DESCRIPTION:  Check for exiftool folder in temporary folder. Download 
#                 selected version if not available.
#    PARAMETERS:  
#       RETURNS:  Set $exifExe global variable with path to executable
#-------------------------------------------------------------------------------
prepareExifTool ()
{
    local version="10.50"
    if [ ! -d /tmp/Image-ExifTool-$version ]; then
        echo 'Getting Exif Tool'
        local ldir=$(pwd)
        cd /tmp
        wget -q -O - http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-$version.tar.gz | gunzip -c | tar -xf - &>/dev/null
        cd $ldir
    fi
    exifExe="/tmp/Image-ExifTool-$version/exiftool"
    echo "Exif Tool at $exifExe"
}	# ----------  end of function prepareExifTool  ----------



#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  parseInputs
#   DESCRIPTION:  Check for correctness of the input
#    PARAMETERS:  Input arguments to the script
#       RETURNS:  Error if number of parameters does not mach
#-------------------------------------------------------------------------------
parseInputs ()
{
    if [ $# -ne 1 ]; then
        echo $0: usage: geocpy.sh input_dir
        exit 1
    fi
}	# ----------  end of function parseInputs  ----------


parseInputs $* # verify input
prepareExifTool # check exiftool


inputDir=$1
JPGS="$inputDir*.jpg" # scan for jpg files
# iterate over all jpg
for f in $JPGS
do
    echo "Processing $f"
    # check for dng
    fileNoPath=$(basename $f) # remove path from file name
    fileNoExt="${fileNoPath%.*}" # get file name
    nameDng=$(echo $inputDir$fileNoExt).dng # add initial path and extension of dng
    echo -n "    Looking for $nameDng"
    if [ -f $nameDng ]; then # verify if dng exists
        echo "    Exists"
        $exifExe -tagsFromFile $f -Location:all $nameDng # transfer geo tags
    else
        echo "    Not found"
    fi
done
