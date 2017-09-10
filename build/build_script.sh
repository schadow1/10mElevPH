#! /bin/sh -x

############################################################################
#
# MODULE:       10mElevph map build script
#
# AUTHOR(S):    Ervin Malicdem schadow1@s1expeditions.com
#
# PURPOSE:      Shell script for creating Philippine Contour map for Garmin.
#               Requires Python 2.7, BeautifulSoup 3.20, Phyghtmap 1.74, mkgmap, nsis. 
#
#               This program is licensed under CC-BY-ND under the Creative Commons License (>=v4).
#
#############################################################################

#Set these directory paths

work_dir=------
output_dir=------
split_dir=------
download_link_osmconvert=---
srtmcache=------



#Nothing to change below


# Download poly
wget -c http://download.geofabrik.de/asia/philippines.poly

#Phyghtmap
phyghtmap --polygon=philippines.poly  -j 4 -s 10 -0 -o philippines --srtm=1 --max-nodes-per-tile=0 --max-nodes-per-way=0 --pbf  

# Split the file using splitter.jar
java -ea -Xmx5030m -jar splitter.jar --cache=cache --mapid=1252 --keep-complete=false --mixed philippines.osm.pbf

ls -al

# compile map designed for 4 core processor with 6GB physical mem
java -Xmx1280m -jar mkgmap.jar --read-config=contourargs.list --output-dir=${output_dir} ${split_dir}/*.osm.pbf ELEVPH.TYP

ls -al


cd ${output_dir}

ls -al

# Win Mapsource installer
makensis ph_elev_mapsource_installer_.nsi
mv ph_elev_winmapsource_latest_.exe /home/schadow1/osm/10mElevph/dev/ph_elev_winmapsource_latest_dev.exe

rm *.img 
rm *.tdb 

cd ..
rm *.img 
rm *.tdb

date > log.txt

#Miscellaneous

cd ${download_dir}



