# geocpy
Simple tool for synchronizing geolocation tags between images.

This simple helper uses *exiftool* for synchronizing geolocation tags between corresponding *jpg* and *dng* files that are taken simultaneously by Samsung S7 camera. For some reasons *dng* files do not have location embedded.

# Usage

Copy all files into hard drive. Program try to match names *xxx.jpg* and *xxx.dng*. Run:

```sh
./geocpy.sh /folder/with/images/
``` 

