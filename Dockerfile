FROM alpine AS download
RUN wget https://download.geofabrik.de/europe/great-britain-latest.osm.pbf -O /map.osm.pbf

FROM ghcr.io/project-osrm/osrm-backend AS builder
COPY --from=download /map.osm.pbf /data/
COPY ./profile/ /profile/
RUN osrm-extract -p /profile/artic.lua /data/map.osm.pbf
RUN osrm-partition /data/map.osm.pbf
RUN osrm-customize /data/map.osm.pbf

FROM ghcr.io/project-osrm/osrm-backend AS final
COPY --from=builder /data/map.osrm* /data/
ENTRYPOINT ["osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
