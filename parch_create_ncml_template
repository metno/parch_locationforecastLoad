#!/usr/bin/python

import os
import sys
import string
import cStringIO
from optparse import OptionParser
import psycopg2


template_base = string.Template('''netcdf parch_extractor {
dimensions:
    none = UNLIMITED ; // (0 currently)
    x = $station_count ;
    y = 1 ;
variables:
    short none(none) ;
    int x(x) ;
        x:axis = "x" ;
        x:long_name = "x-coordinate in Cartesian system" ;
        x:standard_name = "projection_x_coordinate" ;
        x:units = "1" ;
    int y(y) ;
        y:axis = "y" ;
        y:long_name = "y-coordinate in Cartesian system" ;
        y:standard_name = "projection_y_coordinate" ;
        y:units = "1" ;
    float latitude(y, x) ;
        latitude:long_name = "latitude" ;
        latitude:standard_name = "latitude" ;
        latitude:units = "degrees_north" ;
    float longitude(y, x) ;
        longitude:long_name = "longitude" ;
        longitude:standard_name = "longitude" ;
        longitude:units = "degrees_east" ;
    int stationid(y, x) ;
        stationid:long_name = "stationid from STINFOSYS" ;
        stationid:standard_name = "weather_station_id" ;
        stationid:units = "1" ;
    float referenceVariable(none, y, x) ;
        referenceVariable:coordinates = "longitude latitude" ;

// global attributes:
        :Conventions = "CF-1.4" ;
        :time_coverage_start = "2003-01-01T11:55:07" ;
        :time_coverage_end = "2003-01-01T13:42:23" ;
data:

 x = $station_range ;

 y = 0 ;

 latitude =
  $latitude_list ;

 longitude =
  $longitude_list ;
  
 stationid =
  $station_list ;
}
''')

def stringify(value_list):
    s = cStringIO.StringIO()
    s.write(str(value_list[0]))
    for value in value_list[1:]:
        s.write(', ' + str(value))
    return s.getvalue()

def get_ncml(stations):

    station_list = []
    latitude_list = []
    longitude_list = []
    
    for station, (longitude, latitude) in stations.items():
        station_list.append(station)
        longitude_list.append(longitude)
        latitude_list.append(latitude)
    

    values = {'station_count': len(station_list),
              'station_range': stringify(range(len(station_list))),
              'station_list': stringify(station_list),
              'latitude_list': stringify(latitude_list),
              'longitude_list': stringify(longitude_list)
              }

    return template_base.substitute(values)

def get_command_line_options():
    usage_summary = '%prog [options]'
    program_description = 'Create ncml output for stations, for use with fimex with the --interpolate.template option'
    parser = OptionParser(usage = usage_summary, 
                          version = '%prog 0.1', 
                          description = program_description,
                          conflict_handler = 'resolve')

    db = parser.add_option_group('Database connection')
    db.add_option('-d', '--database', default='wdb', help='database name (ex. wdb)')
    db.add_option('-h', '--host', help='database host (ex. somehost.met.no)')
    db.add_option('-u', '--user', default=os.getenv('USER'), help='database user name')
    db.add_option('-p', '--port', type='int', help='database port number to connect to')
    
    parsed = parser.parse_args()
    return parsed

def get_connect_string(options):
    connect = cStringIO.StringIO()
    connect.write('dbname=' + options.database)
    if options.host is not None:
        connect.write(' host=' + options.host)
    if options.port is not None:
        connect.write(' port=' + str(options.port))
    connect.write(' user=' + options.user)
    return connect.getvalue()


def get_wanted_stations():
    stations = []
    line = sys.stdin.readline()
    while line:
        line = line.strip()
        if line:
            stations.append(int(line))
        line = sys.stdin.readline()
    return stations


if __name__ == '__main__':

    options, extra = get_command_line_options()
    if len(extra) > 0:
        sys.stderr.write('Unrecognized options: ' + str(extra))
        sys.exit(1)

    try:
        connection = psycopg2.connect(get_connect_string(options))
        cursor = connection.cursor()
        cursor.execute("SELECT wci.begin('wdb', 88,123,88)")
    except Exception, e:
        sys.stderr.write('FATAL: %s\n' % (e,))
        sys.exit(1)
    
    stations = {}
    try:
        for station in get_wanted_stations():
            cursor.execute("SELECT x(placegeometry), y(placegeometry) FROM wci.getplacepoint(%s)", (str(station),))
            result = cursor.fetchall()
            count = len(result)
            if count == 0:
                sys.stderr.write("WARNING: No station %d\n" % (station,))
            elif count > 1:
                sys.stderr.write("WARNING: Many definitions for station %d\n" % (station,))
            else:
                stations[station] = (result[0][0], result[0][1])
    except Exception, e:
        sys.stderr.write('FATAL: %s\n' % (e,))
        sys.exit(1)
        
    print get_ncml(stations)

