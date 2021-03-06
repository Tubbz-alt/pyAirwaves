# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- AIS Messages logging
- ADSB Message logging
- Receiver/source coverage page
- AIS and ADSB quick stats page

### Changed
- **Breaking:** Backend rewritten from python to Elixir
- Frontend: Markers out of the current displayed map bounds are dropped when received
- Renamed srcPosMeta to srcPosMode
- Map now uses the RRZE tile server for SD/HD maps
- *Breaking:* Nginx config now has cache for RRZE tile server, highly recommended to setup!
- Bogus lat/lon are not processed anymore

## [0.0.1]
### Added
- AIS Support
- A bunch of missing indexes
- Help in top left header
- Bootstrap library
- Proper Logging support in frontend javascript
- Day/Night overlay switch
- Markers change color to grey when halflife is reached before deletion
- Scale on bottom-left of the map
- Leaflet hash handling in URL for hotlinking URLs
- Leaflet "Locate Me" control
- Proper /about page
- Ship MMSI always shown in extra infos


### Changed
- **Breaking:** Services files now uses gunicorn for production, please update according to `installation/pyairwaves-*.service` and `installation/nginx.conf`
- Javascript libraries updated
- Maps changed from B&W OSM to only OSM ones plus ESRI World View
- Cleanup some unused python libs
- airSSR & airAIS, headings etc. are now fixed to two decimals
- Resized down the boat icon
- Plane icon is now on coordinates instead of aside
- Markers trail is now hiden by default
- Canvas bounding box of Plane and Boat have been reduced to bigger-length of extremities of the icon plus a small margin
- Header now uses bootstrap
- Removed old sidebar, superseeded by the new v2
- CORS are now forced to uses the config value
- Zoom controls migrated to the sidebar
- Moved version from header to help menu
- SSR renamed to ADSB


### Fixed
- Debug/console.log cleanups
- lastClientName and lastSrc report properly
- shipTypeMeta now reported
- aircraft idInfo is an unknown field, set it at default so it is ignored by frontend
- Debug input message correctly shown or not
