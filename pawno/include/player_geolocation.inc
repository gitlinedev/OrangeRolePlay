/*==============================================================================
                            player_geolocation
                        player_geolocation.inc v1.2
                        Author: Nikita Shtimenko - whale (a.k.a Twixxx / Twixyck)
 
Copyright (c) 2019 Nikita Shtimenko (whale)
 
This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the
use of this software.
 
Permission is granted to anyone to use this software for
any purpose, including commercial applications, and to alter it and
redistribute it freely, subject to the following restrictions:
 
1.  The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software in
    a product, an acknowledgment in the product documentation would be
    appreciated but is not required.
 
2.  Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.
 
3.  This notice may not be removed or altered from any source distribution.
==============================================================================*/
#if defined _player_geolocation_included
    #endinput
#endif
#define _player_geolocation_included

#if !defined _samp_included
    #error Please include <a_samp> first.
#endif

#if !defined HTTP
    #error Please include <a_http> first.
#endif

#if !defined sscanf
    #error Please include <sscanf2> first.
#endif

#define GEO_IP_INFO_DETECT_URL          "ip-api.com/csv/"
#define GEO_IP_INFO_DETECT_URL_FIELDS   "?fields=721887"

#define GEO_MAX_IP_LENGTH               (16 + 1)
#define GEO_MAX_COUNTRY_CODE_LENGTH     (4 + 1)
#define GEO_MAX_COUNTRY_NAME_LENGTH     (32 + 1)
#define GEO_MAX_REGION_CODE_LENGTH      (6 + 1)
#define GEO_MAX_REGION_NAME_LENGTH      (32 + 1)
#define GEO_MAX_CITY_NAME_LENGTH        (32 + 1)
#define GEO_MAX_DISTRICT_NAME_LENGTH    (64 + 1)
#define GEO_MAX_LAT_LON_LENGTH          (12 + 1)
#define GEO_MAX_TIMEZONE_NAME_LENGTH    (64 + 1)
#define GEO_MAX_PROVIDER_NAME_LENGTH    (32 + 1)
#define GEO_MAX_MOBILE_STATUS_LENGTH    (5 + 1)
#define GEO_MAX_PROXY_LENGTH            (5 + 1)

enum e_PLAYER_GEO_INFO
{
    player_country_code[GEO_MAX_COUNTRY_CODE_LENGTH],
    player_country[GEO_MAX_COUNTRY_NAME_LENGTH],
    player_region_code[GEO_MAX_REGION_CODE_LENGTH],
    player_region[GEO_MAX_REGION_NAME_LENGTH],
    player_district[GEO_MAX_DISTRICT_NAME_LENGTH],
    player_city[GEO_MAX_CITY_NAME_LENGTH],
    player_lat[GEO_MAX_LAT_LON_LENGTH],
    player_lon[GEO_MAX_LAT_LON_LENGTH],
    player_timezone[GEO_MAX_TIMEZONE_NAME_LENGTH],
    player_provider[GEO_MAX_PROVIDER_NAME_LENGTH],
    player_mobile_status[GEO_MAX_MOBILE_STATUS_LENGTH],
    player_proxy[GEO_MAX_PROXY_LENGTH]
};
new
    player_geo_none[e_PLAYER_GEO_INFO] = 
    {
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None"
    },
    player_geo[MAX_PLAYERS][e_PLAYER_GEO_INFO],
    player_geo_ip[MAX_PLAYERS][GEO_MAX_IP_LENGTH];

#define GetPlayerIpCountryCode(%0)      player_geo[%0][player_country_code]
#define GetPlayerIpCountry(%0)          player_geo[%0][player_country]
#define GetPlayerIpRegionCode(%0)       player_geo[%0][player_region_code]
#define GetPlayerIpRegion(%0)           player_geo[%0][player_region]
#define GetPlayerIpCity(%0)             player_geo[%0][player_city]
#define GetPlayerIpDistrict(%0)         player_geo[%0][player_district]
#define GetPlayerIpLatitude(%0)         player_geo[%0][player_lat]
#define GetPlayerIpLongtitude(%0)       player_geo[%0][player_lon]
#define GetPlayerIpTimeZone(%0)         player_geo[%0][player_timezone]
#define GetPlayerIpProvider(%0)         player_geo[%0][player_provider]
#define GetPlayerIpMobileStatus(%0)     player_geo[%0][player_mobile_status]
#define GetPlayerIpProxyStatus(%0)      player_geo[%0][player_proxy]

#define GetPlayerIpLat(%0)              GetPlayerIpLatitude(%0)
#define GetPlayerIpLon(%0)              GetPlayerIpLongtitude(%0)

public OnPlayerConnect(playerid)
{
    GetPlayerIp(playerid, player_geo_ip[playerid], GEO_MAX_IP_LENGTH);

    new 
        request[31 - 2 + GEO_MAX_IP_LENGTH];

    strcat(request, GEO_IP_INFO_DETECT_URL);
    strcat(request, player_geo_ip[playerid]);
    strcat(request, GEO_IP_INFO_DETECT_URL_FIELDS);

    HTTP(playerid, HTTP_GET, request, "", "p_geo_OnIpInformationRequested");

#if defined p_geo_OnPlayerConnect
    p_geo_OnPlayerConnect(playerid);
#endif
    return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect p_geo_OnPlayerConnect
#if defined p_geo_OnPlayerConnect
forward p_geo_OnPlayerConnect(playerid);
#endif

forward p_geo_OnIpInformationRequested(playerid, response_code, data[]);
public p_geo_OnIpInformationRequested(playerid, response_code, data[])
{
    if(response_code == 200)
    {
        sscanf(data, "p<,>s[32]s[3]s[6]s[32]s[32]s[64]s[12]s[12]s[64]s[32]s[5]s[5]",
            player_geo[playerid][player_country],
            player_geo[playerid][player_country_code],
            player_geo[playerid][player_region_code],
            player_geo[playerid][player_region],
            player_geo[playerid][player_city],
            player_geo[playerid][player_district],
            player_geo[playerid][player_lat],
            player_geo[playerid][player_lon],
            player_geo[playerid][player_timezone],
            player_geo[playerid][player_provider],
            player_geo[playerid][player_mobile_status],
            player_geo[playerid][player_proxy]);
    }
    else
    {
        player_geo[playerid] = player_geo_none;
    }
    return 1;
}