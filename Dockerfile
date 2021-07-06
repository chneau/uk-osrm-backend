FROM alpine AS download
RUN wget https://download.geofabrik.de/europe/great-britain-latest.osm.pbf -O /map.osm.pbf

FROM osrm/osrm-backend:v5.25.0 AS builder
COPY --from=download /map.osm.pbf /data/
RUN osrm-extract -p /opt/car.lua /data/map.osm.pbf
RUN osrm-partition /data/map.osm.pbf
RUN osrm-customize /data/map.osm.pbf

FROM osrm/osrm-backend:v5.25.0 AS final
COPY --from=builder /data/map.osrm* /data/
ENTRYPOINT ["osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
