#! /bin/sh -x

############################################################################
#
# MODULE:       10mElevph map build script
#
# AUTHOR(S):    Ervin Malicdem schadow1@s1expeditions.com
#
# PURPOSE:      Shell script for creating Philippine Contour map for Garmin.
#               Requires srtm2osm, segmenter, osmconvert, mkgmap, nsis. 
#
#               This program is licensed under CC-BY-NC-SA under the Creative Commons License (>=v3).
#
#############################################################################

#Set these directory paths

work_dir=------
output_dir=------
split_dir=------
download_link_osmconvert=---
srtmcache=------



#Nothing to change below
#===========
cd ${srtmcache}

# Download 3 arc-second DEM
wget -c http://www.viewfinderpanoramas.org/dem3/F51.zip
wget -c http://www.viewfinderpanoramas.org/dem3/E50.zip
wget -c http://www.viewfinderpanoramas.org/dem3/E51.zip
wget -c http://www.viewfinderpanoramas.org/dem3/D50.zip
wget -c http://www.viewfinderpanoramas.org/dem3/D51.zip
wget -c http://www.viewfinderpanoramas.org/dem3/C50.zip
wget -c http://www.viewfinderpanoramas.org/dem3/C51.zip
wget -c http://www.viewfinderpanoramas.org/dem3/C52.zip
wget -c http://www.viewfinderpanoramas.org/dem3/B50.zip
wget -c http://www.viewfinderpanoramas.org/dem3/B51.zip
wget -c http://www.viewfinderpanoramas.org/dem3/B52.zip
ls -al

# Download OSMConvert
cd ${work_dir}
wget -O ${download_link_osmconvert}
ls -al

# Convert DEM data to OSM Readable Data
srtm2osm -bounds1 4.41242 116.75387 21.53320 126.54074 -step 10 -cat 400 100 -large -corrxy 0.0005 0.0006 -large -o ph.srtm.osm

# Fix over segments
SRTM2OSMsegmenter -i=ph.srtm.osm -o=ph2.srtm.osm -s=250 -w=1

# Convert OSM file to O5M
osmconvert ph2.srtm.osm --out-o5m -o=philippines.o5m

# Lock unclosed segments to boundary
wget -c http://download.geofabrik.de/asia/philippines.poly
osmconvert philippines.o5m -B=philippines.poly --complete-ways -o=philippines.osm

# Split the file using splitter.jar
java -ea -Xmx5030m -jar splitter.jar --cache=cache --max-nodes=1000000 --mapid=12520000 --keep-complete=false --mixed philippines.osm

ls -al

# compile map designed for 4 core processor with 6GB physical mem
java -Xmx1258m -jar mkgmap.jar --read-config=contourargs.list --output-dir=${output_dir} ${split_dir}/*.osm.pbf ELEVPH.TYP

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



