#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY ["nosh_now_apis/nosh_now_apis.csproj", "nosh_now_apis/"]
RUN dotnet restore "nosh_now_apis/nosh_now_apis.csproj"

COPY . .
WORKDIR "/src/nosh_now_apis/"

# RUN dotnet tool install --global dotnet-ef --version 7.0.16
# ENV PATH="$PATH:/root/.dotnet/tools"


RUN dotnet build "nosh_now_apis.csproj" -c Release -o /app/build


FROM build AS publish
RUN dotnet publish "nosh_now_apis.csproj" -c Release -o /app/publish /p:UseAppHost=false


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "nosh_now_apis.dll"]