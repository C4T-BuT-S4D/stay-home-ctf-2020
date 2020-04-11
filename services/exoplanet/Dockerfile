FROM mcr.microsoft.com/dotnet/core/sdk:3.1

MAINTAINER @keltecc

ADD exoplanet /tmp/exoplanet
RUN dotnet publish -c Release -o /srv/exoplanet /tmp/exoplanet 

WORKDIR /srv/exoplanet/
ENTRYPOINT dotnet exoplanet.dll
