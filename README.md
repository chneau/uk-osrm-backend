# uk-osrm-backend

## OSMR truck profile

Profile modified and taken from https://github.com/Project-OSRM/osrm-profiles-contrib

## OSRM docker

- [Docker hub page](https://hub.docker.com/r/osrm/osrm-backend/)
- UK pbf file [(1.3gb)](https://download.geofabrik.de/europe/great-britain-latest.osm.pbf)
- Scotland pdf file [(186mb)](https://download.geofabrik.de/europe/great-britain/scotland-latest.osm.pbf)

```sh
# example with the scotland map

# download the file
curl https://download.geofabrik.de/europe/great-britain/scotland-latest.osm.pbf -o map.osm.pbf

# pre process it, this will create a bunch of files
docker run --rm -it -v `pwd`:/data osrm/osrm-backend osrm-extract -p /opt/car.lua /data/map.osm.pbf
docker run --rm -it -v `pwd`:/data osrm/osrm-backend osrm-partition /data/map.osm.pbf
docker run --rm -it -v `pwd`:/data osrm/osrm-backend osrm-customize /data/map.osm.pbf

# start server
docker run --rm -it -v `pwd`:/data -p 5000:5000 osrm/osrm-backend osrm-routed --algorithm mld /data/map.osrm
```
