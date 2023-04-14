FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build

ENV PROJECT_NAME=Bomber.FileService.Api


WORKDIR /app

# copy csproj and restore as distinct layers
COPY src/$PROJECT_NAME/*.csproj .

RUN dotnet restore -r alpine-x64 /p:PublishReadyToRun=true

# copy and publish app and libraries
COPY src/$PROJECT_NAME/. .

RUN dotnet publish -c Release -o /out -r alpine-x64 --sc true --no-restore \
    /p:PublishTrimmed=true \
    /p:PublishReadyToRun=true \
    /p:PublishSingleFile=true

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:7.0-alpine AS publish

WORKDIR /app
COPY --from=build /out .

EXPOSE 80
ENTRYPOINT ["./Bomber.FileService.Api"]